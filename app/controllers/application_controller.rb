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

  # def current_user
  # 	@current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  
  def is_authorized
    render json: {error: "Please sign-in for access"} unless is_signed_in
  end

  def is_signed_in
    !!authorize
  end

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    else
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      begin
        decoded = JsonWebToken.decode(header)
        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end
    if @current_user.present?
      crm_config()
    end
  end

  def crm_config()
    if @current_user.present?
      # CRM
      @crms = Crm.where(user_id: @current_user.id, status: true).first
      if @crms.present? && @crms.oauth
        if @crms.oauth['access_token'].present?
          access_token = @crms.oauth['access_token']
          case @crms.entity
          when "hubspot"
            Hubspot::Config.token(access_token)
          else
            raise StandardError.new "Error Config: type has an invalid value (#{c.entity})"
          end
        end
      else
        puts "crm-oauth: null"
      end

      # Search
      @search = Search.where(user_id: @current_user.id, status: true).first
      if @search.present? && @search.oauth
        if @search.oauth['access_token'].present?
          access_token = @search.oauth['access_token']
          case @search.entity
          when "linkedin"
            Linkedin::Config.token(access_token)
          else
            raise StandardError.new "Error Config: type has an invalid value (#{c.entity})"
          end
        end
      else
        puts "search-oauth: null"
      end
    end
  end
  
end
