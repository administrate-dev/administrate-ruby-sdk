# frozen_string_literal: true

require 'test_helper'

class TransportTest < Minitest::Test
  include ApiTestHelper

  # Use 0 retries for error-mapping tests so faraday-retry doesn't interfere
  def transport_no_retry
    config = Administrate::Configuration.new(api_key: API_KEY, max_retries: 0)
    Administrate::Transport.new(config)
  end

  def test_sends_authorization_header
    stub = stub_request(:get, "#{API_BASE}/test")
           .with(
             headers: { 'Authorization' => "Bearer #{API_KEY}" },
             query: hash_including({})
           )
           .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })
    new_transport.get('test')
    assert_requested stub
  end

  def test_sends_user_agent_header
    stub = stub_request(:get, "#{API_BASE}/test")
           .with(
             headers: { 'User-Agent' => "administrate-ruby/#{Administrate::VERSION}" },
             query: hash_including({})
           )
           .to_return(status: 200, body: '{}', headers: { 'Content-Type' => 'application/json' })
    new_transport.get('test')
    assert_requested stub
  end

  def test_raises_authentication_error_on_401
    stub_request(:get, "#{API_BASE}/test")
      .with(query: hash_including({}))
      .to_return(status: 401, body: { error: 'Unauthorized' }.to_json,
                 headers: { 'Content-Type' => 'application/json' })
    error = assert_raises(Administrate::AuthenticationError) { transport_no_retry.get('test') }
    assert_equal 401, error.status_code
  end

  def test_raises_permission_denied_error_on_403
    stub_request(:get, "#{API_BASE}/test")
      .with(query: hash_including({}))
      .to_return(status: 403, body: { error: 'Forbidden' }.to_json,
                 headers: { 'Content-Type' => 'application/json' })
    assert_raises(Administrate::PermissionDeniedError) { transport_no_retry.get('test') }
  end

  def test_raises_not_found_error_on_404
    stub_request(:get, "#{API_BASE}/test")
      .with(query: hash_including({}))
      .to_return(status: 404, body: { error: 'Not found' }.to_json,
                 headers: { 'Content-Type' => 'application/json' })
    assert_raises(Administrate::NotFoundError) { transport_no_retry.get('test') }
  end

  def test_raises_validation_error_on_422
    stub_request(:get, "#{API_BASE}/test")
      .with(query: hash_including({}))
      .to_return(status: 422, body: { error: 'Invalid' }.to_json,
                 headers: { 'Content-Type' => 'application/json' })
    assert_raises(Administrate::ValidationError) { transport_no_retry.get('test') }
  end

  def test_raises_rate_limit_error_on_429_with_retry_after
    stub_request(:get, "#{API_BASE}/test")
      .with(query: hash_including({}))
      .to_return(status: 429, body: { error: 'Too many requests' }.to_json,
                 headers: { 'Content-Type' => 'application/json', 'Retry-After' => '30' })
    error = assert_raises(Administrate::RateLimitError) { transport_no_retry.get('test') }
    assert_equal 30.0, error.retry_after
  end

  def test_raises_internal_server_error_on_500
    stub_request(:get, "#{API_BASE}/test")
      .with(query: hash_including({}))
      .to_return(status: 500, body: { error: 'Server error' }.to_json,
                 headers: { 'Content-Type' => 'application/json' })
    assert_raises(Administrate::InternalServerError) { transport_no_retry.get('test') }
  end

  def test_raises_api_error_on_unknown_4xx
    stub_request(:get, "#{API_BASE}/test")
      .with(query: hash_including({}))
      .to_return(status: 418, body: { error: "I'm a teapot" }.to_json,
                 headers: { 'Content-Type' => 'application/json' })
    assert_raises(Administrate::APIError) { transport_no_retry.get('test') }
  end

  def test_makes_get_requests
    stub = stub_request(:get, "#{API_BASE}/test")
           .with(query: hash_including({}))
           .to_return(status: 200, body: { data: 'ok' }.to_json,
                      headers: { 'Content-Type' => 'application/json' })
    new_transport.get('test')
    assert_requested stub
  end

  def test_makes_post_requests_with_body
    stub = stub_request(:post, "#{API_BASE}/test")
           .with(body: { name: 'test' }.to_json)
           .to_return(status: 201, body: { data: 'created' }.to_json,
                      headers: { 'Content-Type' => 'application/json' })
    new_transport.post('test', { name: 'test' })
    assert_requested stub
  end

  def test_makes_patch_requests_with_body
    stub = stub_request(:patch, "#{API_BASE}/test/1")
           .with(body: { name: 'updated' }.to_json)
           .to_return(status: 200, body: { data: 'updated' }.to_json,
                      headers: { 'Content-Type' => 'application/json' })
    new_transport.patch('test/1', { name: 'updated' })
    assert_requested stub
  end

  def test_makes_delete_requests
    stub = stub_request(:delete, "#{API_BASE}/test/1")
           .to_return(status: 204, body: '')
    new_transport.delete('test/1')
    assert_requested stub
  end

  def test_raises_timeout_error_on_timeout
    stub_request(:get, "#{API_BASE}/test")
      .with(query: hash_including({}))
      .to_timeout
    assert_raises(Administrate::TimeoutError) { transport_no_retry.get('test') }
  end
end
