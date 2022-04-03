class ApplicationController < ActionController::API
  def initialize()
    # CRM
    Hubspot::Config.configure(
      hapikey: "727955",
      client_id: "f77bc478-c758-4dbf-8ee5-5dead3879324",
      client_secret: "8b693453-cda5-4a69-add8-665914987d5e",
      redirect_uri: "http://localhost:3001/crm/hubspot/callback",
    )

    # Search
    Linkedin::Config.configure(
      client_id: "866x9isyhvoml3",
      client_secret: "OmrI0uwZi4u8Jg3t",
      redirect_uri: "http://localhost:3001/search/linkedin/callback",
    )
  end
  
  def current_user
    @current_user if !current_user.nil?
  end

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = JsonWebToken.decode(header)
      @current_user = User.find(decoded[:user_id])
      if @current_user.present?
        crm_config
      else
        return render json: { errors: 'Invalid token' }
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def authorize_admin
    #@current_user.admin.present?
  end

  def crm_config
    if @current_user.present?
      @crms = Crm.where(user_id: @current_user.id).all
      @crms.each do |c|
        if c.oauth['access_token'].present?
          access_token = c.oauth['access_token']
          case c.entity
          when "hubspot"
            Hubspot::Config.token(access_token)
          else
            raise StandardError.new "Error Config: type has an invalid value (#{c.entity})"
          end
        end
      end
    end
  end
end
