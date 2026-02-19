# frozen_string_literal: true

module Administrate
  class Client
    attr_reader :account, :users, :webhooks, :api_tokens, :clients,
                :instances, :workflows, :executions, :sync_runs,
                :llm_providers, :llm_projects, :llm_costs

    def initialize(api_key:, base_url: DEFAULT_BASE_URL, timeout: DEFAULT_TIMEOUT, max_retries: DEFAULT_MAX_RETRIES)
      config = Configuration.new(api_key: api_key, base_url: base_url, timeout: timeout, max_retries: max_retries)
      transport = Transport.new(config)

      @account = Resources::Account.new(transport)
      @users = Resources::Users.new(transport)
      @webhooks = Resources::Webhooks.new(transport)
      @api_tokens = Resources::ApiTokens.new(transport)
      @clients = Resources::Clients.new(transport)
      @instances = Resources::Instances.new(transport)
      @workflows = Resources::Workflows.new(transport)
      @executions = Resources::Executions.new(transport)
      @sync_runs = Resources::SyncRuns.new(transport)
      @llm_providers = Resources::LlmProviders.new(transport)
      @llm_projects = Resources::LlmProjects.new(transport)
      @llm_costs = Resources::LlmCosts.new(transport)
    end
  end
end
