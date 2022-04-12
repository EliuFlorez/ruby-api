class AuthenticationController < ApplicationController
  before_action :authorize, except: %i[ signin signup ]

  # POST /auth/signin
  def signin
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      token = JsonWebToken.encode(user_id: @user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, expire: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
    else
      render json: { error: 'Email or Password invalid' }, status: :unauthorized
    end
  end

  # POST /auth/signup
  def signup
    @user = User.new(signup_params)

    if @user.save
      #session[:user_id] = @user.id
      render json: { success: true }, status: :created, location: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def singin_params
    params.permit(:email, :password)
  end

  def signup_params
    params.permit(:id, :name, :email, :password, :password_confirmation)
  end
end
