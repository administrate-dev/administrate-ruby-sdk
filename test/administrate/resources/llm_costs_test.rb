# frozen_string_literal: true

require 'test_helper'

class LlmCostsResourceTest < Minitest::Test
  include ApiTestHelper

  def test_summary
    stub_api(:get, 'llm_costs', body: {
               data: {
                 summary: { total_cost_cents: 5000, total_tokens: 100_000, total_input_tokens: 60_000,
                            total_output_tokens: 40_000, total_requests: 500, providers_count: 2 },
                 providers: [{ id: 'lp1', name: 'OpenAI', provider_type: 'openai',
                               cost_cents: 3000, tokens: 60_000, requests: 300 }],
                 models: [{ model: 'gpt-4', cost_cents: 3000, tokens: 60_000, requests: 300 }],
                 daily: [{ date: '2024-01-01', cost_cents: 100, tokens: 2000 }]
               },
               meta: { start_date: '2024-01-01', end_date: '2024-01-31' }
             })

    result = new_client.llm_costs.summary(start_date: '2024-01-01', end_date: '2024-01-31')
    assert_instance_of Administrate::Resources::LlmCostSummaryResponse, result
    assert_instance_of Administrate::Models::LlmCostSummaryData, result.data
    assert_instance_of Administrate::Models::LlmCostSummaryMeta, result.meta
    assert_equal 5000, result.data.summary.total_cost_cents
    assert_equal 1, result.data.providers.size
    assert_equal 1, result.data.models.size
    assert_equal 1, result.data.daily.size
  end

  def test_by_client
    stub_api(:get, 'llm_costs/by_client', body: {
               data: [{ id: 'c1', name: 'Acme', cost_cents: 2000, tokens: 40_000 }],
               meta: { start_date: '2024-01-01', end_date: '2024-01-31' }
             })

    result = new_client.llm_costs.by_client
    assert_instance_of Administrate::Resources::LlmCostByClientResponse, result
    assert_equal 1, result.data.size
    assert_instance_of Administrate::Models::LlmCostByClient, result.data[0]
  end

  def test_by_provider
    stub_api(:get, 'llm_costs/by_provider', body: {
               data: [{ id: 'lp1', name: 'OpenAI', provider_type: 'openai',
                        cost_cents: 3000, tokens: 60_000, requests: 300 }],
               meta: { start_date: '2024-01-01', end_date: '2024-01-31' }
             })

    result = new_client.llm_costs.by_provider
    assert_instance_of Administrate::Resources::LlmCostByProviderResponse, result
    assert_equal 1, result.data.size
    assert_instance_of Administrate::Models::LlmCostByProvider, result.data[0]
  end
end
