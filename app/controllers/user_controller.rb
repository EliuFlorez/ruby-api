class UserController < ApplicationController
  before_action :authorize
  before_action :set_user, only: %i[ index create update destroy password ]

  # GET /users
  def index
    render json: @user, status: :ok
  end

  # GET /users/1
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    if @user.update(set_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(set_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  def password
    if @user.present? && @user.token_save!("password")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(@current_user.id)
    end

    def set_params
      if params[:type].blank?
        render json: { error: 'User Type invalid.' }
      end
      case params[:type]
        when "detail"
          detail_params
        when "twofa"
          twofa_params
        else
          raise StandardError.new "Error User: type has an invalid params"
        end
    end

    # Only allow a list of trusted parameters through.
    def detail_params
      params.permit(
        :first_name, 
        :last_name, 
        :email
      )
    end

    def twofa_params
      params.permit(
        :sign_in_twofa
      )
    end
end
