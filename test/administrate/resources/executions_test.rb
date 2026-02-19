# frozen_string_literal: true

require 'test_helper'

class ExecutionsResourceTest < Minitest::Test
  include ApiTestHelper

  def execution_data(overrides = {})
    { id: 'e1', workflow_id: 'w1', workflow_name: 'Daily Sync', instance_id: 'i1',
      instance_name: 'Production', client_id: 'c1', client_name: 'Acme',
      status: 'success', created_at: '2024-01-01' }.merge(overrides)
  end

  def test_list
    stub_api(:get, 'executions', body: paginated_response([execution_data]))

    items = new_client.executions.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::Execution, items[0]
  end

  def test_list_with_filters
    stub = stub_request(:get, "#{API_BASE}/executions")
           .with(query: hash_including('client_id' => 'c1', 'errors_only' => 'true'))
           .to_return(status: 200, body: paginated_response([execution_data]).to_json,
                      headers: { 'Content-Type' => 'application/json' })

    new_client.executions.list(client_id: 'c1', errors_only: true).to_a
    assert_requested stub
  end

  def test_get
    stub_api(:get, 'executions/e1', body: { data: execution_data })

    execution = new_client.executions.get('e1')
    assert_equal 'e1', execution.id
    assert_equal 'success', execution.status
  end
end
