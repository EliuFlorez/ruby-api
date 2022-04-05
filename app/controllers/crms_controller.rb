class CrmsController < ApplicationController
  before_action :authorize_admin
  before_action :set_crm, only: %i[ show update destroy ]

  # GET /crms
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
      @crms = Crm.where("name like ?", "#{query}%").limit(limit).offset(offset).order(:id)
      total = @crms.count
    else
      @crms = Crm.limit(limit).offset(offset).order(:id)
      total = Crm.all.count
    end

    render json: { items: @crms, total: total }, list: true, status: :ok
  end

  # GET /crms/1
  def show
    render json: @crm
  end

  # POST /crms
  def create
    @crm = Crm.new(crm_params)

    if @crm.save
      render json: @crm, status: :created, location: @crm
    else
      render json: @crm.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /crms/1
  def update
    if @crm.update(crm_params)
      render json: @crm
    else
      render json: @crm.errors, status: :unprocessable_entity
    end
  end

  # DELETE /crms/1
  def destroy
    @crm.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crm
      @crm = Crm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def crm_params
      params.permit(:id, :user_id, :name, :entity, :status)
    end
end
