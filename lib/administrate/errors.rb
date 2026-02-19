# frozen_string_literal: true

module Administrate
  class Error < StandardError; end

  class APIError < Error
    attr_reader :status_code, :response, :body

    def initialize(message, status_code:, response:, body:)
      @status_code = status_code
      @response = response
      @body = body
      super(message)
    end
  end

  class AuthenticationError < APIError; end
  class PermissionDeniedError < APIError; end
  class NotFoundError < APIError; end
  class ValidationError < APIError; end

  class RateLimitError < APIError
    attr_reader :retry_after

    def initialize(message, status_code:, response:, body:, retry_after: nil)
      @retry_after = retry_after
      super(message, status_code: status_code, response: response, body: body)
    end
  end

  class InternalServerError < APIError; end
  class ConnectionError < Error; end
  class TimeoutError < Error; end

  STATUS_CODE_MAP = {
    401 => AuthenticationError,
    403 => PermissionDeniedError,
    404 => NotFoundError,
    422 => ValidationError,
    429 => RateLimitError
  }.freeze
end
