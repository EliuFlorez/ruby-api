class HomeController < ApplicationController
  # GET /index
  def index
    render json: { api: 'OK', version: '1.0' }, status: :ok
  end
end
