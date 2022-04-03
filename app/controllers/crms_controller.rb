class CrmsController < ApplicationController
  #before_action :authorize, only: %i[ connect callback ]
  before_action :set_crm, only: %i[ show create update destroy ]

  # GET /crms
  def index
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

    if query.present?
      @crms = Crm.where("name like ?", "#{query}%").limit(limit).offset(offset).order(:id)
    else
      @crms = Crm.limit(limit).offset(offset).order(:id)
    end

    render json: { items: @crms, count: @crms.count }, list: true, status: :ok
  end

  # GET /crms/1
  def show
    render json: @crm
  end

  # POST /crms
  def create
    if @crm.update(crm_params)
      render json: @crm
    else
      render json: @crm.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /crms/1
  def update
    if @crm.update(crm_params)
      render json: @crm
    else
      render json: @crm.errors, status: :unprocessable_entity
    end
  end

  # DELETE /crms/1
  def destroy
    @crm.destroy
  end

  def connect
    if params[:type].blank?
      return render json: { error: 'Oauth Type invalid.' }
    end
    
    # Oauth Authorize
    url_oauth = CrmProvider.oauth(params[:type]).authorize_url()
    
    # Redirection
    redirect_to url_oauth, allow_other_host: true
  end

  def callback
    if params[:type].blank?
      return render json: { error: 'Oauth Type invalid.' }
    end

    if params[:code].blank?
      return render json: { error: 'Oauth Code invalid.' }
    end

    # Oauth Code
    oauth = CrmProvider.oauth(params[:type]).callback(params[:code])
    oauth = ActiveSupport::JSON.encode(oauth)
    
    # Crm Create o Update
    crm = Crm.find_or_create_by(user_id: 1, entity: params[:type])
    crm.update(name: params[:type], oauth: oauth)

    # Redirection
    redirect_to "http://localhost:3001/crms"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crm
      @crm = Crm.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def crm_params
      params.permit(:id, :name, :entity, :status)
    end
end
