module Admin
  class PermissionsController < ApplicationController
    before_action :authorize
    before_action :authorize_admin
    before_action :set_permission, only: %i[ show update destroy ]

    # GET /permissions
    def index
      # Variable
      query = nil
      limit = 20
      offset = 0

      if params[:query].present?
        query = params[:query]
      end

      if params[:limit].present?
        limit = params[:limit]
      end

      if params[:offset].present?
        offset = params[:offset]
      end

      total = 0

      if query.present?
        @permissions = Permission.where("name like ?", "#{query}%").limit(limit).offset(offset).order(:id)
        total = @permissions.count
      else
        @permissions = Permission.limit(limit).offset(offset).order(:id)
        total = Permission.all.count
      end

      render json: { items: @permissions, total: total }, list: true, status: :ok
    end

    # GET /permissions/1
    def show
      render json: @permission
    end

    # POST /permissions
    def create
      @permission = Permission.new(permission_params)

      if @permission.save
        render json: @permission, status: :created, location: @permission
      else
        render json: @permission.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /permissions/1
    def update
      if @permission.update(permission_params)
        render json: @permission
      else
        render json: @permission.errors, status: :unprocessable_entity
      end
    end

    # DELETE /permissions/1
    def destroy
      @permission.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_permission
        @permission = Permission.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def permission_params
        params.permit(:name)
      end
  end
end