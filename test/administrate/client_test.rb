# frozen_string_literal: true

require 'test_helper'

class ClientTest < Minitest::Test
  def test_creates_client_with_valid_api_key
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Client, client
  end

  def test_raises_error_for_empty_api_key
    error = assert_raises(Administrate::Error) { Administrate::Client.new(api_key: '') }
    assert_match(/api_key is required/, error.message)
  end

  def test_raises_error_for_invalid_api_key_prefix
    error = assert_raises(Administrate::Error) { Administrate::Client.new(api_key: 'invalid_key') }
    assert_match(/api_key must start with 'sk_live_'/, error.message)
  end

  def test_has_account_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::Account, client.account
  end

  def test_has_users_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::Users, client.users
  end

  def test_has_webhooks_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::Webhooks, client.webhooks
  end

  def test_has_api_tokens_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::ApiTokens, client.api_tokens
  end

  def test_has_clients_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::Clients, client.clients
  end

  def test_has_instances_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::Instances, client.instances
  end

  def test_has_workflows_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::Workflows, client.workflows
  end

  def test_has_executions_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::Executions, client.executions
  end

  def test_has_sync_runs_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::SyncRuns, client.sync_runs
  end

  def test_has_llm_providers_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::LlmProviders, client.llm_providers
  end

  def test_has_llm_projects_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::LlmProjects, client.llm_projects
  end

  def test_has_llm_costs_resource
    client = Administrate::Client.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Resources::LlmCosts, client.llm_costs
  end

  def test_convenience_new_method
    client = Administrate.new(api_key: 'sk_live_test_123')
    assert_instance_of Administrate::Client, client
  end
end
