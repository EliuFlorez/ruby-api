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
    @prospect = Prospect.find_or_create_by(prospect_params)
    if @prospect.present?
      prospect_property(@prospect)
    else
      render json: { errors: "prospect exists" }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /prospects/1
  def update
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
      params.permit(:id, :user_id, :crm_id, :entity, :name, :uid, :perfile_id, :perfile_url, :picture_url, :status)
    end

    def prospect_property(prospect)
      puts "params: #{params.inspect}"
      if params[:fields].present? && params[:fields].count > 0
        params[:fields].each do |f|
          property = Property.find_or_create_by(prospect_id: prospect.id, field_name: f.name)
          property.update(field_value: f.value)
        end

        # ApiCrm.contacts.create()

        render json: prospect
      else
        render json: { errors: "property field null" }, status: :unprocessable_entity
      end
    end
end
