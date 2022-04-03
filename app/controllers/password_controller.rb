class PasswordController < ApplicationController
  before_action :authorize, except: %i[forgot reset]
  
  def forgot
    if params[:email].blank?
      return render json: {error: 'Email not present'}
    end

    user = User.find_by(email: params[:email])

    if user.present?
      user.token_save!("password")
      #UserMailer.password_email(@user).deliver_now
      render json: { success: true }, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  def reset
    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end

    if params[:password].blank?
      return render json: { error: 'Password not present' }
    end
    
    user = User.find_by(reset_password_token: params[:token])

    if user.present? && user.token_valid!("password")
      if user.token_reset!("password", params[:password])
        render json: { success: true }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error:  ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  end
end
