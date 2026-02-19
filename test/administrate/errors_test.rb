# frozen_string_literal: true

require 'test_helper'

class ErrorsTest < Minitest::Test
  def test_error_inherits_from_standard_error
    assert Administrate::Error.ancestors.include?(StandardError)
  end

  def test_api_error_inherits_from_error
    assert Administrate::APIError.ancestors.include?(Administrate::Error)
  end

  def test_authentication_error_inherits_from_api_error
    assert Administrate::AuthenticationError.ancestors.include?(Administrate::APIError)
  end

  def test_permission_denied_error_inherits_from_api_error
    assert Administrate::PermissionDeniedError.ancestors.include?(Administrate::APIError)
  end

  def test_not_found_error_inherits_from_api_error
    assert Administrate::NotFoundError.ancestors.include?(Administrate::APIError)
  end

  def test_validation_error_inherits_from_api_error
    assert Administrate::ValidationError.ancestors.include?(Administrate::APIError)
  end

  def test_rate_limit_error_inherits_from_api_error
    assert Administrate::RateLimitError.ancestors.include?(Administrate::APIError)
  end

  def test_internal_server_error_inherits_from_api_error
    assert Administrate::InternalServerError.ancestors.include?(Administrate::APIError)
  end

  def test_connection_error_inherits_from_error
    assert Administrate::ConnectionError.ancestors.include?(Administrate::Error)
  end

  def test_timeout_error_inherits_from_error
    assert Administrate::TimeoutError.ancestors.include?(Administrate::Error)
  end

  def test_api_error_stores_attributes
    error = Administrate::APIError.new('test', status_code: 400, response: nil, body: { error: 'bad' })
    assert_equal 400, error.status_code
    assert_equal({ error: 'bad' }, error.body)
    assert_equal 'test', error.message
  end

  def test_rate_limit_error_stores_retry_after
    error = Administrate::RateLimitError.new('rate limited', status_code: 429, response: nil, body: nil,
                                                             retry_after: 30.0)
    assert_equal 30.0, error.retry_after
  end
end
