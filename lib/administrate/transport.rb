# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'

module Administrate
  class Transport
    def initialize(config)
      @config = config
      @base_url = "#{config.base_url.chomp('/')}/api/#{API_VERSION}"
      @connection = build_connection
    end

    def get(path, params = {})
      handle_request { @connection.get(url_for(path), params) }
    end

    def post(path, body = {})
      handle_request { @connection.post(url_for(path), body) }
    end

    def patch(path, body = {})
      handle_request { @connection.patch(url_for(path), body) }
    end

    def delete(path)
      handle_request { @connection.delete(url_for(path)) }
    end

    private

    def url_for(path)
      "#{@base_url}/#{path.sub(%r{^/}, '')}"
    end

    def build_connection
      Faraday.new do |f|
        f.request :json
        f.request :retry,
                  max: @config.max_retries,
                  interval: 0.5,
                  backoff_factor: 2,
                  retry_statuses: [429, 500, 502, 503, 504],
                  retry_block: ->(**_) {}
        f.response :json, content_type: /\bjson$/
        f.headers = default_headers
        f.options.timeout = @config.timeout
        f.options.open_timeout = @config.timeout
      end
    end

    def default_headers
      {
        'Authorization' => "Bearer #{@config.api_key}",
        'User-Agent' => "administrate-ruby/#{VERSION}",
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }
    end

    def handle_request
      response = yield
      handle_response(response)
      response
    rescue Faraday::TimeoutError => e
      raise Administrate::TimeoutError, "Request timed out: #{e.message}"
    rescue Faraday::ConnectionFailed => e
      if e.cause.is_a?(::Timeout::Error) || e.cause.is_a?(Net::OpenTimeout)
        raise Administrate::TimeoutError, "Request timed out: #{e.message}"
      end

      raise Administrate::ConnectionError, "Connection failed: #{e.message}"
    end

    def handle_response(response)
      return if response.success?

      body = response.body
      message = if body.is_a?(Hash)
                  body['error'] || response.reason_phrase
                else
                  body.to_s
                end

      status = response.status
      exc_class = STATUS_CODE_MAP[status]

      if exc_class == RateLimitError
        retry_after = response.headers['Retry-After']
        retry_after = retry_after.to_f if retry_after
        raise RateLimitError.new(message, status_code: status, response: response, body: body, retry_after: retry_after)
      elsif exc_class
        raise exc_class.new(message, status_code: status, response: response, body: body)
      elsif status >= 500
        raise InternalServerError.new(message, status_code: status, response: response, body: body)
      else
        raise APIError.new(message, status_code: status, response: response, body: body)
      end
    end
  end
end
