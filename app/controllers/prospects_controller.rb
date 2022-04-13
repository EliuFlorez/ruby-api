class ProspectsController < ApplicationController
  before_action :authorize
  before_action :set_prospect, only: %i[ show update destroy ]

  # GET /prospects
  def index
    # Variable
    query = nil
    limit = 20
    offset = 0

    if params[:query].present?
      query = params[:query]
    end

    if params[:limit].present?
      limit = params[:limit]
    end

    if params[:offset].present?
      offset = params[:offset]
    end

    total = 0

    if query.present?
      @prospects = Prospect.includes(:properties)
        .where(user_id: @current_user.id)
        .where("name like ?", "#{query}%").limit(limit).offset(offset).order(:id)
      total = @prospects.count
    else
      @prospects = Prospect.includes(:properties)
        .where(user_id: @current_user.id).limit(limit).offset(offset).order(:id)
      total = Prospect.all.count
    end

    render json: { items: @prospects, total: total }, list: true, status: :ok
  end

  # GET /prospects/1
  def show
    render json: @prospect
  end

  # POST /prospects
  def create
    # Type
    # validate_type()
    # Find or Create
    # @prospect = Prospect.find_or_create_by(prospect_params)
    # if @prospect.present?
    #   prospect_property(@prospect)
    # else
    #   render json: { errors: "prospect exists" }, status: :unprocessable_entity
    # end
    @prospect = Prospect.new(prospect_params)

    if @prospect.save
      render json: @prospect, status: :created, location: @prospect
    else
      render json: @prospect.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prospects/1
  def update
    # Type
    # validate_type()
    # Update
    # if @prospect.update(prospect_params)
    #   prospect_property(@prospect)
    # else
    #   render json: @prospect.errors, status: :unprocessable_entity
    # end
  end

  # DELETE /prospects/1
  def destroy
    @prospect.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.where(id: params[:id], user_id: @current_user.id).first
    end

    # Only allow a list of trusted parameters through.
    def prospect_params
      params.permit(:id, :user_id, :crm_id, :entity, :name, :uid, :perfile_url, :picture_url)
    end

    def validate_type()
      if params[:type].blank?
        return render json: { error: 'Oauth Type invalid.' }
      end
    end

    def prospect_property(prospect)
      # JSON
      json = JSON.parse("[]")
      if params[:fields].present?
        json = JSON.parse(params[:fields])
      end
      # JSON Fields
      if json.size > 0
        json.each do |f|
          property = Property.find_or_create_by(prospect_id: prospect.id, field_name: f.name)
          property.update(field_value: f.value)
        end
        # Type
        type = params[:type]
        # Api Call
        contact = ApiCrm.contacts(type).find_by_email("email@email.com")
        if contact.size == 0
          ApiCrm.contacts(type).create(
            name: "Second Financial LLC."
          )
        end
        # Render
        render json: prospect
      else
        render json: { errors: "property field null" }, status: :unprocessable_entity
      end
    end
end
