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
    type = validate_type()

    # Find or Create
    @prospect = Prospect.find_or_create_by(params_find)
    
    # Present
    if @prospect.present?
      if @prospect.update(params_update)
        prospect_property(type, @prospect.id)
      else
        render json: @prospect.errors, status: :unprocessable_entity
      end
    else
      render json: { errors: "prospect exists" }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prospects/1
  def update
    # Type
    type = validate_type()

    # Find or Create
    @prospect = Prospect.find_or_create_by(params_find)
    
    # Present
    if @prospect.present?
      if @prospect.update(params_update)
        prospect_property(type, @prospect.id)
      else
        render json: @prospect.errors, status: :unprocessable_entity
      end
    else
      render json: { errors: "prospect exists" }, status: :unprocessable_entity
    end
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
    def params_find
      params.permit(:user_id, :crm_id, :entity, :uid)
    end

    def params_update
      params.permit(:name, :profile_url, :picture_url)
    end

    def validate_type()
      if params[:type].blank?
        render json: { error: 'Oauth Type invalid.' }
      end

      return params[:type]
    end

    def prospect_property(type, id)
      fields = params[:fields]

      # JSON Fields
      if fields.size > 0
        fields.each do |f|
          property = Property.find_or_create_by(prospect_id: id, field_name: f['name'])
          property.update(field_value: f['value'])
        end
        # # Api Call
        # contact = ApiCrm.contacts(type).find_by_email("email@email.com")
        # if contact.size == 0
        #   ApiCrm.contacts(type).create(
        #     name: "Second Financial LLC."
        #   )
        # end
        # Render
        render json: { success: true }
      else
        render json: { errors: "property field null" }, status: :unprocessable_entity
      end
    end
end
