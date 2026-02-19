# frozen_string_literal: true

require 'minitest/autorun'
require 'webmock/minitest'
require 'administrate-sdk'

WebMock.disable_net_connect!

module ApiTestHelper
  API_KEY = 'sk_live_test_key_123'
  BASE_URL = 'https://administrate.dev'
  API_BASE = "#{BASE_URL}/api/v1".freeze

  def new_client
    Administrate::Client.new(api_key: API_KEY)
  end

  def stub_api(method, path, status: 200, body: {}, request_body: nil)
    url = "#{API_BASE}/#{path}"
    response_body = body.is_a?(String) ? body : body.to_json
    stub = stub_request(method, url)

    with_opts = {}
    with_opts[:query] = hash_including({}) if %i[get].include?(method)
    with_opts[:body] = request_body if request_body
    stub = stub.with(with_opts) unless with_opts.empty?

    stub.to_return(
      status: status,
      body: response_body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def paginated_response(data, page: 1, per_page: 25, total: nil, has_more: false)
    total ||= data.size
    total_pages = [(total.to_f / per_page).ceil, 1].max
    {
      data: data,
      meta: {
        page: page,
        per_page: per_page,
        total: total,
        total_pages: total_pages,
        has_more: has_more
      }
    }
  end

  def new_transport
    config = Administrate::Configuration.new(api_key: API_KEY)
    Administrate::Transport.new(config)
  end
end
