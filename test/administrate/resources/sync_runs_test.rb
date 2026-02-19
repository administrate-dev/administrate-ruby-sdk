# frozen_string_literal: true

require 'test_helper'

class SyncRunsResourceTest < Minitest::Test
  include ApiTestHelper

  def sync_run_data(overrides = {})
    { id: 'sr1', instance_id: 'i1', instance_name: 'Production', sync_type: 'workflows',
      status: 'completed', records_created: 5, records_updated: 2,
      created_at: '2024-01-01' }.merge(overrides)
  end

  def test_list
    stub_api(:get, 'sync_runs', body: paginated_response([sync_run_data]))

    items = new_client.sync_runs.list.to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::SyncRun, items[0]
  end

  def test_get
    stub_api(:get, 'sync_runs/sr1', body: { data: sync_run_data })

    sync_run = new_client.sync_runs.get('sr1')
    assert_equal 'sr1', sync_run.id
  end

  def test_health
    stub_api(:get, 'sync_health', body: {
               data: [
                 { instance_id: 'i1', instance_name: 'Production', client_id: 'c1', client_name: 'Acme',
                   sync_status: 'synced',
                   workflows: { last_synced_at: '2024-01-01', last_run: nil },
                   executions: { last_synced_at: '2024-01-01', last_run: nil } }
               ]
             })

    entries = new_client.sync_runs.health
    assert_equal 1, entries.size
    assert_instance_of Administrate::Models::SyncHealthEntry, entries[0]
    assert_equal 'i1', entries[0].instance_id
    assert_instance_of Administrate::Models::SyncHealthSyncInfo, entries[0].workflows
  end
end
