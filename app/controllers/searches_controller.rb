class SearchesController < ApplicationController
  before_action :set_search, only: %i[ show create update destroy ]

  # GET /searches
  def index
    @searches = Search.all

    render json: @searches
  end

  # GET /searches/1
  def show
    render json: @search
  end

  # POST /searches
  def create
    if @search.update(search_params)
      render json: @search
    else
      render json: @search.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /searches/1
  def update
    if @search.update(search_params)
      render json: @search
    else
      render json: @search.errors, status: :unprocessable_entity
    end
  end

  # DELETE /searches/1
  def destroy
    @search.destroy
  end

  def connect
    if params[:type].blank?
      return render json: { error: 'Oauth Type invalid.' }
    end
    
    # Oauth Authorize
    url_oauth = SearchProvider.oauth(params[:type]).authorize_url()
    
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
    oauth = SearchProvider.oauth(params[:type]).callback(params[:code])

    # Search Create o Update
    crm = Search.find_or_create_by(user_id: 1, entity: params[:type])
    crm.update(name: params[:type], oauth: oauth)

    # Redirection
    redirect_to "http://localhost:3001/searchs"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_search
      @search = Search.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def search_params
      params.permit(:id, :name, :entiry, :status)
    end
end
