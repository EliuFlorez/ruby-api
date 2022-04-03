class ProspectsController < ApplicationController
  before_action :authorize
  before_action :set_prospect, only: %i[ show update destroy ]

  # GET /prospects
  def index
    @prospects = Prospect.all.includes(:properties)
    render json: @prospects
  end

  # GET /prospects/1
  def show
    render json: @prospect
  end

  # POST /prospects
  def create
    # Type
    validate_type()
    # Find or Create
    @prospect = Prospect.find_or_create_by(prospect_params)
    if @prospect.present?
      prospect_property(@prospect)
    else
      render json: { errors: "prospect exists" }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prospects/1
  def update
    # Type
    validate_type()
    # Update
    if @prospect.update(prospect_params)
      prospect_property(@prospect)
    else
      render json: @prospect.errors, status: :unprocessable_entity
    end
  end

  # DELETE /prospects/1
  def destroy
    @prospect.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prospect
      @prospect = Prospect.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def prospect_params
      params.permit(:id, :type, :user_id, :crm_id, :entity, :name, :uid, :perfile_id, :perfile_url, :picture_url, :status)
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
