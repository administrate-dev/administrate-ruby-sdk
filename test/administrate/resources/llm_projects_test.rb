# frozen_string_literal: true

require 'test_helper'

class LlmProjectsResourceTest < Minitest::Test
  include ApiTestHelper

  def project_data(overrides = {})
    { id: 'proj1', name: 'My Project', total_cost_cents: 1500, total_tokens: 50_000,
      created_at: '2024-01-01', updated_at: '2024-01-01' }.merge(overrides)
  end

  def test_list
    stub_api(:get, 'llm_providers/lp1/llm_projects', body: paginated_response([project_data]))

    items = new_client.llm_projects.list('lp1').to_a
    assert_equal 1, items.size
    assert_instance_of Administrate::Models::LlmProject, items[0]
  end

  def test_update
    stub_api(:patch, 'llm_providers/lp1/llm_projects/proj1', body: {
               data: project_data(client_id: 'c1')
             })

    project = new_client.llm_projects.update('lp1', 'proj1', client_id: 'c1')
    assert_equal 'c1', project.client_id
  end
end
