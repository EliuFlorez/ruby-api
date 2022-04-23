class PasswordController < ApplicationController
  before_action :authorize, except: %i[ forgot token reset ]
  
  def forgot
    if params[:email].blank?
      return render json: {error: 'Email not present'}
    end

    user = User.find_by(email: params[:email])

    if user.present?
      user.token_save!("password")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :not_found
    end
  end

  def token
    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end
    
    @user = User.find_by(password_token: params[:token])

    if @user.present? && @user.token_valid!("password")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
    end
  end

  def reset
    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end
    
    @user = User.find_by(password_token: params[:token])

    if @user.present? && @user.token_valid!("password")
      if @user.update(reset_params)
        if @user.token_reset!("password")
          render json: { success: true }, status: :ok
        else
          render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(password_token: params[:token])
    end

    # Only allow a list of trusted parameters through.
    def reset_params
      params.permit(:password, :password_confirmation, :password_token)
    end
end
