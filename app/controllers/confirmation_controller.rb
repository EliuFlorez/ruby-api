class ConfirmationController < ApplicationController
  before_action :authorize, except: %i[ link reset ]

  def reset
    if params[:email].blank?
      render json: {error: 'Email not present'}
    end

    user = User.find_by(email: params[:email])

    if user.present?
      user.token_save!("confirmation")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :unprocessable_entity
    end
  end

  def link
    if params[:token].blank?
      render json: { error: 'Token not present' }
    end

    user = User.find_by(confirmation_token: params[:token])

    if user.present? && user.token_valid!("confirmation")
      if user.token_reset!("confirmation")
        render json: { success: true }, status: :ok
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :unprocessable_entity
    end
  end

  private

  def confirmation_params
    params.require(:user).permit(:confirmation_token)
  end
end
