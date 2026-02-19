# frozen_string_literal: true

require 'test_helper'

class ConfigurationTest < Minitest::Test
  def test_sets_defaults
    config = Administrate::Configuration.new(api_key: 'sk_live_test_123')
    assert_equal 'sk_live_test_123', config.api_key
    assert_equal 'https://administrate.dev', config.base_url
    assert_equal 30, config.timeout
    assert_equal 3, config.max_retries
  end

  def test_accepts_custom_values
    config = Administrate::Configuration.new(
      api_key: 'sk_live_custom',
      base_url: 'https://custom.example.com',
      timeout: 60,
      max_retries: 5
    )
    assert_equal 'https://custom.example.com', config.base_url
    assert_equal 60, config.timeout
    assert_equal 5, config.max_retries
  end

  def test_raises_error_for_nil_api_key
    error = assert_raises(Administrate::Error) { Administrate::Configuration.new(api_key: nil) }
    assert_match(/api_key is required/, error.message)
  end

  def test_raises_error_for_empty_api_key
    error = assert_raises(Administrate::Error) { Administrate::Configuration.new(api_key: '') }
    assert_match(/api_key is required/, error.message)
  end

  def test_raises_error_for_invalid_api_key_prefix
    error = assert_raises(Administrate::Error) { Administrate::Configuration.new(api_key: 'bad_key') }
    assert_match(/api_key must start with 'sk_live_'/, error.message)
  end
end
