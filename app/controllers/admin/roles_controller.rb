module Admin
  class RolesController < ApplicationController
    before_action :authorize
    before_action :authorize_admin
    before_action :set_role, only: %i[ show update destroy ]

    # GET /roles
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
        @roles = Role.where("name like ?", "#{query}%").limit(limit).offset(offset).order(:id)
        total = @roles.count
      else
        @roles = Role.limit(limit).offset(offset).order(:id)
        total = Role.all.count
      end

      render json: { items: @roles, total: total }, list: true, status: :ok
    end

    # GET /roles/1
    def show
      render json: @role
    end

    # POST /roles
    def create
      @role = Role.new(role_params)

      if @role.save
        render json: @role, status: :created, location: @role
      else
        render json: @role.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /roles/1
    def update
      if @role.update(role_params)
        render json: @role
      else
        render json: @role.errors, status: :unprocessable_entity
      end
    end

    # DELETE /roles/1
    def destroy
      @role.destroy
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_role
        @role = Role.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def role_params
        params.permit(:name)
      end
  end
end