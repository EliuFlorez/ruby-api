require 'logger'
require 'linkedin/connection'

module Linkedin
  class Config
    CONFIG_KEYS = [
      :base_url, :logger, :access_token, :client_id,
      :client_secret, :redirect_uri, :read_timeout, :open_timeout
    ]
    
    DEFAULT_LOGGER = Logger.new(nil)
    DEFAULT_BASE_URL = "https://api.linkedin.com/v2/".freeze

    class << self
      attr_accessor *CONFIG_KEYS

      def configure(config)
        config.stringify_keys!
        @base_url = config["base_url"] || DEFAULT_BASE_URL
        @logger = config["logger"] || DEFAULT_LOGGER
        @access_token = config["access_token"]
        @client_id = config["client_id"] if config["client_id"].present?
        @client_secret = config["client_secret"] if config["client_secret"].present?
        @redirect_uri = config["redirect_uri"] if config["redirect_uri"].present?
        @read_timeout = config['read_timeout'] || config['timeout']
        @open_timeout = config['open_timeout'] || config['timeout']

        if access_token.present?
          Linkedin::Connection.headers("Authorization" => "Bearer #{access_token}")
        end
        self
      end

      def token(access_token)
        if access_token.present?
          Linkedin::Connection.headers("Authorization" => "Bearer #{access_token}")
        end
      end

      def reset!
        @base_url = DEFAULT_BASE_URL
        @logger = DEFAULT_LOGGER
        @access_token = nil
        Linkedin::Connection.headers({})
      end

      def ensure!(*params)
        params.each do |p|
          raise ConfigurationError.new("'#{p}' not configured") unless instance_variable_get "@#{p}"
        end
      end

      private

      def authentication_uncertain?
        access_token.present?
      end
    end

    reset!
  end
end
