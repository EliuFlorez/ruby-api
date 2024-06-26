require 'httparty'

module Linkedin
  class Oauth < Connection
    include HTTParty

    DEFAULT_OAUTH_HEADERS = {"Content-Type" => "application/x-www-form-urlencoded;charset=utf-8"}

    class << self
      def refresh(token, params={}, options={})
        oauth_post(token_url, { grant_type: "refresh_token", refresh_token: token }.merge(params), options)
      end

      def callback(code, params={}, options={})
        oauth_post(token_url, { grant_type: "authorization_code", code: code }.merge(params), options)
      end

      def authorize_url(params={})
        client_id = params[:client_id] || Linkedin::Config.client_id
        redirect_uri = params[:redirect_uri] || Linkedin::Config.redirect_uri
        scopes = Array.wrap([
          "r_liteprofile",
          "r_emailaddress",
          "w_member_social"
        ])
				
				"https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=#{client_id}&redirect_uri=#{redirect_uri}&state=foobar&scope=#{scopes.join("%20")}"
      end

      def token_url
        token_url = "https://www.linkedin.com/oauth/v2/accessToken"
      end

      def oauth_post(url, params, options={})
        no_parse = options[:no_parse] || false

        body = {
          client_id: Linkedin::Config.client_id,
          client_secret: Linkedin::Config.client_secret,
          redirect_uri: Linkedin::Config.redirect_uri,
        }.merge(params)

        response = post(url, body: body, headers: DEFAULT_OAUTH_HEADERS)
        log_request_and_response url, response, body

        raise(RequestError.new(response)) unless response.success?

        no_parse ? response : response.parsed_response
      end

    end
  end
end
