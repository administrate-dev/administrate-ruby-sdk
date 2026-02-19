# frozen_string_literal: true

require 'test_helper'

class ApiTokensResourceTest < Minitest::Test
  include ApiTestHelper

  def token_data(overrides = {})
    { id: 'tok_1', name: 'My Token', permission: 'full_access', permission_label: 'Full Access',
      token_hint: 'sk_live_...abc', ip_allowlist: [], revoked: false, active: true,
      created_by: { id: 'u1', name: 'User' }, created_at: '2024-01-01',
      updated_at: '2024-01-01' }.merge(overrides)
  end

  def test_list
    stub_api(:get, 'api_tokens', body: paginated_response([token_data]))

    items = new_client.api_tokens.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::ApiToken, items[0]
  end

  def test_get
    stub_api(:get, 'api_tokens/tok_1', body: { data: token_data })

    token = new_client.api_tokens.get('tok_1')
    assert_equal 'tok_1', token.id
    assert_instance_of Administrate::Models::ApiTokenCreatedBy, token.created_by
  end

  def test_create
    stub_api(:post, 'api_tokens', body: { data: token_data(token: 'sk_live_full_token') })

    token = new_client.api_tokens.create(name: 'My Token')
    assert_equal 'sk_live_full_token', token.token
  end

  def test_update
    stub_api(:patch, 'api_tokens/tok_1', body: { data: token_data(name: 'Updated') })

    token = new_client.api_tokens.update('tok_1', name: 'Updated')
    assert_equal 'Updated', token.name
  end

  def test_delete
    stub_request(:delete, "#{API_BASE}/api_tokens/tok_1")
      .to_return(status: 204, body: '')
    assert_nil new_client.api_tokens.delete('tok_1')
  end
end
