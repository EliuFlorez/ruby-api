class AuthenticationController < ApplicationController
  before_action :authorize, except: %i[signin signup check_email]

  # POST /auth/signin
  def signin
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, expire: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  # POST /auth/signup
  def signup
    @user = User.new(signup_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  private

  def singin_params
    params.permit(:email, :password)
  end

  def signup_params
    params.permit(:id, :name, :username, :email, :password, :password_confirmation)
  end
end
