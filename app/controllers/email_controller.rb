class EmailController < ApplicationController
  before_action :authorize, only: %i[ send ]
  before_action :set_user, only: %i[ send ]
  
  def link
    if @user.present? && @user.token_save!("email")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :unprocessable_entity
    end
  end

  def token
    if params[:token].blank?
      render json: { error: 'Token not present' }
    end
    
    @user = User.find_by(change_email_token: params[:token])

    if @user.present? && @user.token_valid!("email")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :unprocessable_entity
    end
  end

  def change
    if params[:password_token].blank?
      render json: { error: 'Token not present' }
    end
    
    @user = User.find_by(change_email_token: params[:change_email_token])

    if @user.present? && @user.token_valid!("email")
      if @user.update(set_params)
        if @user.token_reset!("email")
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
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(@current_user.id)
    end

    # Only allow a list of trusted parameters through.
    def set_params
      params.permit(:email, :change_email_token)
    end
end
