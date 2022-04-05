class UsersController < ApplicationController
  before_action :authorize
  before_action :set_user, only: %i[ create update destroy ]

  # GET /users
  def index
    render json: @current_user
  end

  # GET /users/1
  def show
    render json: @current_user
  end

  # POST /users
  def create
    # Disanble
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
      id = @current_user.id
      @user = User.find(id)
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:id, :name, :username, :email, :password, :password_confirmation)
    end
end
