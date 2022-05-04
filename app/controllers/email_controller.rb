class EmailController < ApplicationController
  before_action :authorize, only: %i[ link ]
  before_action :set_user, only: %i[ link ]
  
  def link
    if @user.present? && @user.token_save!("email")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Email address not found. Please check and try again.' }, status: :unprocessable_entity
    end
  end

  def token
    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end
    
    @user = User.find_by(change_email_token: params[:token])

    if @user.present? && @user.token_valid!("email")
      render json: { success: true }, status: :ok
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :unprocessable_entity
    end
  end

  def change
    if params[:token].blank?
      return render json: { error: 'Token not present' }
    end
    
    @user = User.find_by(change_email_token: params[:token])

    if @user.present? #&& @user.token_valid!("email")
      if User.find_by(email: params[:email_old])
        if @user.update(email: params[:email_new]) && @user.token_reset!("email")
          render json: { success: true }, status: :ok
        else
          render json: { errors: @user.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Email is invalid' }, status: :unprocessable_entity  
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
end
