require 'httparty'

module Linkedin
  class Connection
    include HTTParty

    class << self
      def api(method, url, params={})
        #for retries in 1..5 do
          begin
            # may raise an exception
    
            case method
            when "get"
              response = get_json(url, params: params)
            when "post"
              response = post_json(url, params: params)
            when "put"
              response = put_json(url, params: params)
            when "delete"
              response = delete_json(url, id: params[:id])
            else
              "Error: method has an invalid value (#{method})"
            end
    
            if response.code == 401
              # refreshToken;
            end
    
            if response.code == 0
              #sleep 5
              #next
            end
    
            if response.code >= 500 || response.code <= 599 
              #sleep 5
              #next
            end
    
            check_http_code(response);
    
            if response.success?
              response.parsed_response
            else
              raise(RequestError.new(response))
            end
          rescue StandardError => e
            # if retries < 4
            #   sleep 2
            # else
            #   raise StandardError.new "Exception Class: #{ e.class.name }, Message: #{ e.message }, Backtrace: #{ e.backtrace }"
            # end
          rescue RateLimitException => e
            # if retries < 4
            #   sleep e.seconds_to_reset + retries
            # else
            #   raise StandardError.new "Exception Class: #{ e.class.name }, Message: #{ e.message }, Backtrace: #{ e.backtrace }"
            # end
          rescue Exception => e
            # if retries < 4
            #   sleep 1
            # else
            #   raise StandardError.new "Exception Class: #{ e.class.name }, Message: #{ e.message }, Backtrace: #{ e.backtrace }"
            # end
          else
            # other exceptions
          ensure
            # always executed
          end
        #end
      end
    
      def check_http_code(response)
        case response.code
        when 502, 500, 504, 524
          raise StandardError.new "API appears to be temporarily down"
        when 429
          raise StandardError.new "API rate limit"
        when 401
          raise StandardError.new "Your not authorized"
        when 414
          raise StandardError.new "Internal integration issue"
        when 403
          raise StandardError.new "Does not have permission to access this resource"
        when 400
          raise StandardError.new "Is already in the process of being merged"
        when 404
          raise StandardError.new "The access token is expired or invalid"
        when 409
          raise StandardError.new "Internal integration issue"
        when 409
          raise StandardError.new "Internal integration issue"
        else
          if response.code < 100 || response.code > 299
            raise StandardError.new "Internal integration issue"
          end
        end
      end

      def get_json(path, opts)
        url = generate_url(path, opts)

        puts "linkedinUrl: #{url}"

        response = get(
          url, 
          format: :json, 
          read_timeout: read_timeout(opts), 
          open_timeout: open_timeout(opts)
        )
        
        log_request_and_response(url, response)

        handle_response(response)
      end

      def post_json(path, opts)
        no_parse = opts[:params].delete(:no_parse) { false }

        url = generate_url(path, opts[:params])
        response = post(
          url,
          body: opts[:body].to_json,
          headers: { 'Content-Type' => 'application/json' },
          format: :json,
          read_timeout: read_timeout(opts),
          open_timeout: open_timeout(opts)
        )

        log_request_and_response(url, response, opts[:body])

        raise(RequestError.new(response)) unless response.success?

        no_parse ? response : response.parsed_response
      end

      def put_json(path, options)
        no_parse = options[:params].delete(:no_parse) { false }
        url = generate_url(path, options[:params])

        response = put(
          url,
          body: options[:body].to_json,
          headers: { "Content-Type" => "application/json" },
          format: :json,
          read_timeout: read_timeout(options),
          open_timeout: open_timeout(options),
        )

        log_request_and_response(url, response, options[:body])
        
        raise(RequestError.new(response)) unless response.success?

        no_parse ? response : response.parsed_response
      end

      def delete_json(path, opts)
        url = generate_url(path, opts)
        response = delete(
          url, 
          format: :json, 
          read_timeout: read_timeout(opts), 
          open_timeout: open_timeout(opts)
        )
        
        log_request_and_response(url, response, opts[:body])

        raise(RequestError.new(response)) unless response.success?
        
        response
      end

      protected

      def read_timeout(opts = {})
        opts.delete(:read_timeout) || Linkedin::Config.read_timeout
      end

      def open_timeout(opts = {})
        opts.delete(:open_timeout) || Linkedin::Config.open_timeout
      end

      def handle_response(response)
        if response.success?
          response.parsed_response
        else
          raise(RequestError.new(response))
        end
      end

      def log_request_and_response(uri, response, body=nil)
        Linkedin::Config.logger.info(<<~MSG)
          Linkedin: #{uri}.
          Body: #{body}.
          Response: #{response.code} #{response.body}
        MSG
      end

      def generate_url(path, params={}, options={})        
        path = path.clone
        params = params.clone
        base_url = options[:base_url] || Linkedin::Config.base_url

        params.each do |k,v|
          if path.match(":#{k}")
            path.gsub!(":#{k}", CGI.escape(v.to_s))
            params.delete(k)
          end
        end

        raise(MissingInterpolation.new("Interpolation not resolved")) if path =~ /:/

        query = params.map do |k,v|
          v.is_a?(Array) ? v.map { |value| param_string(k,value) } : param_string(k,v)
        end.join("&")

        path += path.include?('?') ? '&' : "?" if query.present?
        base_url + path + query
      end

      # convert into milliseconds since epoch
      def converted_value(value)
        value.is_a?(Time) ? (value.to_i * 1000) : CGI.escape(value.to_s)
      end

      def param_string(key,value)
        case key
        when /range/
          raise "Value must be a range" unless value.is_a?(Range)
          "#{key}=#{converted_value(value.begin)}&#{key}=#{converted_value(value.end)}"
        when /^batch_(.*)$/
          key = $1.gsub(/(_.)/) { |w| w.last.upcase }
          "#{key}=#{converted_value(value)}"
        else
          "#{key}=#{converted_value(value)}"
        end
      end
    end
  end
end
