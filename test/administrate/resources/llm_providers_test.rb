# frozen_string_literal: true

require 'test_helper'

class LlmProvidersResourceTest < Minitest::Test
  include ApiTestHelper

  def provider_data(overrides = {})
    { id: 'lp1', name: 'OpenAI', provider_type: 'openai', projects_count: 3,
      created_at: '2024-01-01', updated_at: '2024-01-01' }.merge(overrides)
  end

  def test_list
    stub_api(:get, 'llm_providers', body: paginated_response([provider_data]))

    items = new_client.llm_providers.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::LlmProvider, items[0]
  end

  def test_get
    stub_api(:get, 'llm_providers/lp1', body: { data: provider_data })

    provider = new_client.llm_providers.get('lp1')
    assert_equal 'lp1', provider.id
  end

  def test_create
    stub_api(:post, 'llm_providers', body: { data: provider_data })

    provider = new_client.llm_providers.create(name: 'OpenAI', provider_type: 'openai', api_key: 'sk-test')
    assert_instance_of Administrate::Models::LlmProvider, provider
  end

  def test_update
    stub_api(:patch, 'llm_providers/lp1', body: { data: provider_data(name: 'Updated') })

    provider = new_client.llm_providers.update('lp1', name: 'Updated')
    assert_equal 'Updated', provider.name
  end

  def test_delete
    stub_request(:delete, "#{API_BASE}/llm_providers/lp1")
      .to_return(status: 204, body: '')
    assert_nil new_client.llm_providers.delete('lp1')
  end

  def test_sync
    stub_api(:post, 'llm_providers/lp1/sync', body: { message: 'Sync started' })

    result = new_client.llm_providers.sync('lp1')
    assert_equal 'Sync started', result['message']
  end
end
