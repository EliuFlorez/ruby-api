class ConfirmationController < ApplicationController
  before_action :authorize, except: %i[index reset]
  
  def link
    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end

    user = User.find_by(confirmation_token: params[:token])

    if user.present? && user.token_valid!("confirmation")
      if user.token_reset!("confirmation", "")
        #UserMailer.activation_email(@user).deliver_now
        render json: { success: true }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error:  ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  end

  def reset
    if params[:email].blank?
      return render json: {error: 'Email not present'}
    end

    user = User.find_by(email: params[:email])

    if user.present?
      user.token_save!("confirmation")
      #UserMailer.confirmation_email(@user).deliver_now
      render json: { success: true }, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  private

  def confirmation_params
    params.require(:user).permit(:confirmation_token)
  end
end
