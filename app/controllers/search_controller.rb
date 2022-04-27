class SearchController < ApplicationController
  before_action :authorize
  
  def index
    response = Linkedin::Connection.api("get", "emailAddress?q=members&projection=(elements*(handle~))")
    render json: response, status: :ok
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
    crm = Search.find_or_create_by(user_id: @current_user.id, entity: params[:type])
    crm.update(name: params[:type], oauth: oauth)

    # Redirection
    redirect_to "http://localhost:3000/app/overview"
  end
end
