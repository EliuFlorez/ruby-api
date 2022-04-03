class ValidController < ApplicationController
  # POST /check/email
  def email
    user = User.find_by_email(params[:value])
    render json: { success: user.present? }, status: :ok
  end

  # POST /check/username
  def username
    user = User.find_by_username(params[:value])
    render json: { success: user.present? }, status: :ok
  end
end
