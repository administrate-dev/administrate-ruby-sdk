# frozen_string_literal: true

require 'test_helper'

class InstancesResourceTest < Minitest::Test
  include ApiTestHelper

  def instance_data(overrides = {})
    { id: 'i1', service_type: 'n8n', company_id: 'c1', company_name: 'Acme',
      name: 'Production', base_url: 'https://n8n.example.com', workflows_count: 5,
      sync_status: 'synced', created_at: '2024-01-01', updated_at: '2024-01-01' }.merge(overrides)
  end

  def test_list
    stub_api(:get, 'instances', body: paginated_response([instance_data]))

    items = new_client.instances.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::Instance, items[0]
  end

  def test_list_with_client_id_maps_to_company_id
    stub = stub_request(:get, "#{API_BASE}/instances")
           .with(query: hash_including('company_id' => 'c1'))
           .to_return(status: 200, body: paginated_response([instance_data]).to_json,
                      headers: { 'Content-Type' => 'application/json' })

    new_client.instances.list(client_id: 'c1').to_a
    assert_requested stub
  end

  def test_get
    stub_api(:get, 'instances/i1', body: { data: instance_data })

    instance = new_client.instances.get('i1')
    assert_equal 'i1', instance.id
  end

  def test_create
    stub_api(:post, 'instances', body: { data: instance_data })

    instance = new_client.instances.create(
      client_id: 'c1', name: 'Production',
      base_url: 'https://n8n.example.com', api_key: 'key123'
    )
    assert_instance_of Administrate::Models::Instance, instance
  end

  def test_update
    stub_api(:patch, 'instances/i1', body: { data: instance_data(name: 'Staging') })

    instance = new_client.instances.update('i1', name: 'Staging')
    assert_equal 'Staging', instance.name
  end

  def test_delete
    stub_request(:delete, "#{API_BASE}/instances/i1")
      .to_return(status: 204, body: '')
    assert_nil new_client.instances.delete('i1')
  end

  def test_sync
    stub_api(:post, 'instances/i1/sync', body: { message: 'Sync started' })

    result = new_client.instances.sync('i1', sync_type: 'workflows')
    assert_equal 'Sync started', result['message']
  end

  def test_sync_all
    stub_api(:post, 'instances/sync_all', body: { message: 'Sync started for all' })

    result = new_client.instances.sync_all
    assert_equal 'Sync started for all', result['message']
  end
end
