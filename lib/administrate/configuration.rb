# frozen_string_literal: true

module Administrate
  DEFAULT_BASE_URL = 'https://administrate.dev'
  API_VERSION = 'v1'
  DEFAULT_TIMEOUT = 30
  DEFAULT_MAX_RETRIES = 3

  class Configuration
    attr_reader :api_key, :base_url, :timeout, :max_retries

    def initialize(api_key:, base_url: DEFAULT_BASE_URL, timeout: DEFAULT_TIMEOUT, max_retries: DEFAULT_MAX_RETRIES)
      raise Administrate::Error, 'api_key is required' if api_key.nil? || api_key.empty?
      raise Administrate::Error, "api_key must start with 'sk_live_'" unless api_key.start_with?('sk_live_')

      @api_key = api_key
      @base_url = base_url
      @timeout = timeout
      @max_retries = max_retries
    end
  end
end
