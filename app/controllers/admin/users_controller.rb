module Admin
  class UsersController < ApplicationController
    before_action :authorize
    before_action :authorize_admin
    before_action :set_user, only: %i[ show update destroy ]

    # GET /users
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
        @users = User.where("email like ?", "#{query}%").limit(limit).offset(offset).order(:id)
        total = @users.count
      else
        @users = User.limit(limit).offset(offset).order(:id)
        total = User.all.count
      end

      render json: { items: @users, total: total }, list: true, status: :ok
    end

    # GET /users/1
    def show
      render json: @user
    end

    # POST /users
    def create
      @user = User.new(user_params)

      if @user.save
        render json: @user, status: :created, location: @role
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user.update(user_params)
        render json: @user
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.permit(:name)
      end
  end
end