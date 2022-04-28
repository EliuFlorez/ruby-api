class CrmsController < ApplicationController
  before_action :authorize
  before_action :set_crm, only: %i[ show create update destroy ]

  # GET /crms
  def index
    @crm = Crm.where(user_id: @current_user.id, status: true).first
    @crms = Crm.where(user_id: @current_user.id)
    
    render json: { current: @crm, results: @crms }, list: true, status: :ok
  end

  # GET /crms/1
  def show
    render json: @crm
  end

  # POST /crms
  def create
    if @crm.update(crm_params)
      render json: @crm
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
      @crm = Crm.where(id: params[:id], user_id: @current_user).first
    end

    # Only allow a list of trusted parameters through.
    def crm_params
      params.permit(:id, :user_id, :name, :status)
    end
end
