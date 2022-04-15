class UsersController < ApplicationController
  before_action :authorize
  before_action :set_user, only: %i[ index create update destroy ]

  # GET /users
  def index
    render json: { user: @user, crms: @user.crms }, status: :ok
  end

  # GET /users/1
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    if @user.update(user_params)
      render json: @user
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
      @user = User.find(@current_user.id)
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:id, :name, :email, :password, :password_confirmation)
    end
end
