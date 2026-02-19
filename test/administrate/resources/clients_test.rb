# frozen_string_literal: true

require 'test_helper'

class ClientsResourceTest < Minitest::Test
  include ApiTestHelper

  def client_data(overrides = {})
    { id: 'c1', name: 'Acme Corp', n8n_instances_count: 2,
      created_at: '2024-01-01', updated_at: '2024-01-01' }.merge(overrides)
  end

  def test_list
    stub_api(:get, 'clients', body: paginated_response([client_data]))

    items = new_client.clients.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::Client, items[0]
  end

  def test_get
    stub_api(:get, 'clients/c1', body: { data: client_data })

    client = new_client.clients.get('c1')
    assert_equal 'c1', client.id
    assert_equal 'Acme Corp', client.name
  end

  def test_create
    stub_api(:post, 'clients', body: { data: client_data })

    client = new_client.clients.create(name: 'Acme Corp')
    assert_instance_of Administrate::Models::Client, client
  end

  def test_update
    stub_api(:patch, 'clients/c1', body: { data: client_data(name: 'Updated Corp') })

    client = new_client.clients.update('c1', name: 'Updated Corp')
    assert_equal 'Updated Corp', client.name
  end

  def test_delete
    stub_request(:delete, "#{API_BASE}/clients/c1")
      .to_return(status: 204, body: '')
    assert_nil new_client.clients.delete('c1')
  end
end
