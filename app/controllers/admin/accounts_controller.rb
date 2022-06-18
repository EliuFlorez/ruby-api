module Admin
  class AccountsController < ApplicationController
    before_action :authorize
    before_action :set_account, only: %i[ show update destroy ]

    # GET /accounts
    def index
      @accounts = Account.all
    end

    # GET /accounts/1
    def show
      render json: @account
    end

    # POST /accounts
    def create
      @account = Account.new(account_params)

      if @account.save
        render json: @account, status: :created, location: @account
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /accounts/1
    def update
      if @account.update(account_params)
        render json: @account, status: :ok, location: @account
      else
        render json: @account.errors, status: :unprocessable_entity
      end
    end

    # DELETE /accounts/1
    def destroy
      @account.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_account
        user_id = @current_user.id
        @account = Account.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def account_params
        params.require(:account).permit(:name)
      end
  end
end