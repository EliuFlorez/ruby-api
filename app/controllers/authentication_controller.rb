class AuthenticationController < ApplicationController
  #before_action :authorize, except: %i[ logout ]

  # POST /auth/signin
  def signin
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      if @user.sign_in_twofa
        if @user.token_save!("code")
          ## Send Email Code
          render json: { twofa: true, token: @user.twofa_code_token }, status: :ok
        else
          render json: { error: 'Error code twofa' }, status: :unauthorized
        end
      else
        session[:user_id] = @user.id
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, expire: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
      end
    else
      render json: { error: 'Email or Password invalid' }, status: :unauthorized
    end
  end

  # POST /auth/signin/code
  def signin_code
    if params[:code].blank?
      render json: { error: 'Code not present' }
    end

    @user = User.find_by(twofa_code: params[:code])
    
    if @user.present?
      if @user.token_reset!("code")
        session[:user_id] = @user.id
        token = JsonWebToken.encode(user_id: @user.id)
        time = Time.now + 24.hours.to_i
        render json: { token: token, expire: time.strftime("%m-%d-%Y %H:%M") }, status: :ok
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Code invalid' }, status: :unauthorized
    end
  end

  # GET /auth/signin/:code
  def signin_valid
    if params[:token].blank?
      render json: { error: 'Token not present' }
    end
    
    @user = User.find_by(twofa_code_token: params[:token])

    if @user.present? && @user.token_valid!("code")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :unprocessable_entity
    end
  end

  # POST /auth/signup
  def signup
    if params[:token].present?
      @user = User.find_by(invitation_token: params[:token])
      if @user.present? && @user.token_valid!("invitation")
        if @user.update(signup_params)
          if @user.token_reset!("invitation")
            render json: { success: true }, status: :ok
          else
            render json: { errors: @user.errors }, status: :unprocessable_entity
          end
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :unprocessable_entity
      end
    else
      @user = User.new(signup_params)
      if @user.save
        session[:user_id] = @user.id
        render json: { success: true }, status: :created, location: @user
      else
        render json: { errors: @user.errors }, status: :unprocessable_entity
      end
    end
  end

  # GET /auth/signup/invitation
  def signup_invitation
    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end

    @user = User.find_by(invitation_token: params[:token])

    if @user.present? && @user.token_valid!("invitation")
      render json: @user, status: :ok
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :unprocessable_entity
    end
  end

  def logout
    session.delete(:user_id)
    
    render json: { success: true }, status: :ok
  end

  private

  def singin_params
    params.permit(:email, :password)
  end

  def signup_params
    params.permit(:id, :first_name, :last_name, :email, :password, :password_confirmation)
  end
end
