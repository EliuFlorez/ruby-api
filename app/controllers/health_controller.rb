class HealthController < ApplicationController
  # GET /index
  def index
    render json: { api: 'OK' }, status: :ok
  end
end
