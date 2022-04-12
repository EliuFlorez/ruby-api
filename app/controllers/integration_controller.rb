class IntegrationController < ApplicationController
  #before_action :authorize
  
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
    redirect_to "http://localhost:3000/app/overview"
  end
end
