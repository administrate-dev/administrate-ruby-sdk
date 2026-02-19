# frozen_string_literal: true

require 'test_helper'

class WorkflowsResourceTest < Minitest::Test
  include ApiTestHelper

  def workflow_data(overrides = {})
    { id: 'w1', instance_id: 'i1', instance_name: 'Production', company_id: 'c1',
      company_name: 'Acme', name: 'Daily Sync', is_active: true,
      created_at: '2024-01-01', updated_at: '2024-01-01' }.merge(overrides)
  end

  def test_list
    stub_api(:get, 'workflows', body: paginated_response([workflow_data]))

    items = new_client.workflows.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::Workflow, items[0]
  end

  def test_list_with_client_id_maps_to_company_id
    stub = stub_request(:get, "#{API_BASE}/workflows")
           .with(query: hash_including('company_id' => 'c1'))
           .to_return(status: 200, body: paginated_response([workflow_data]).to_json,
                      headers: { 'Content-Type' => 'application/json' })

    new_client.workflows.list(client_id: 'c1').to_a
    assert_requested stub
  end

  def test_get
    stub_api(:get, 'workflows/w1', body: { data: workflow_data })

    workflow = new_client.workflows.get('w1')
    assert_equal 'w1', workflow.id
  end

  def test_update
    stub_api(:patch, 'workflows/w1', body: {
               data: workflow_data(minutes_saved_per_success: 5.0)
             })

    workflow = new_client.workflows.update('w1', minutes_saved_per_success: 5.0)
    assert_equal 5.0, workflow.minutes_saved_per_success
  end
end
