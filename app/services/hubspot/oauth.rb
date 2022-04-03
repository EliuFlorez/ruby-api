require 'httparty'

module Hubspot
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
        client_id = params[:client_id] || Hubspot::Config.client_id
        redirect_uri = params[:redirect_uri] || Hubspot::Config.redirect_uri
        scopes = Array.wrap([
          "crm.schemas.deals.read",
          "crm.objects.owners.read",
          "crm.objects.contacts.write",
          "crm.objects.companies.write",
          "crm.objects.companies.read",
          "crm.objects.deals.read",
          "crm.schemas.contacts.read",
          "crm.objects.deals.write",
          "crm.objects.contacts.read",
          "crm.schemas.companies.read",
          "crm.lists.read",
          "integration-sync",
          "oauth"
        ])

        "https://app.hubspot.com/oauth/authorize?client_id=#{client_id}&redirect_uri=#{redirect_uri}&scope=#{scopes.join("%20")}"
      end

      def token_url
        token_url = Hubspot::Config.base_url + "/oauth/v1/token"
      end

      def oauth_post(url, params, options={})
        no_parse = options[:no_parse] || false

        body = {
          client_id: Hubspot::Config.client_id,
          client_secret: Hubspot::Config.client_secret,
          redirect_uri: Hubspot::Config.redirect_uri,
        }.merge(params)

        response = post(url, body: body, headers: DEFAULT_OAUTH_HEADERS)
        log_request_and_response url, response, body

        raise(RequestError.new(response)) unless response.success?

        no_parse ? response : response.parsed_response
      end

    end
  end
end
