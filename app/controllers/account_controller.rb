class AccountController < ApplicationController
  before_action :authorize
  before_action :set_account, only: %i[ index create update destroy ]

  # GET /account
  def index
    render json: @account, status: :ok
  end

  # GET /account/1
  def show
    render json: @account, status: :ok
  end

  # POST /account
  def create
    if @account.update(set_params)
      render json: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /account/1
  def update
    if @account.update(set_params)
      render json: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /account/1
  def destroy
    @account.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.where(user_id: @current_user.id)
    end

    # Only allow a list of trusted parameters through.
    def set_params
      params.permit(
        :name,
        :phone,
        :address,
        :address_number,
        :city,
        :provice_state,
        :portal_code,
        :country
      )
    end

end
