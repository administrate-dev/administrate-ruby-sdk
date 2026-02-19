# frozen_string_literal: true

require_relative 'administrate/version'
require_relative 'administrate/errors'
require_relative 'administrate/configuration'
require_relative 'administrate/base_model'
require_relative 'administrate/page'
require_relative 'administrate/models/pagination_meta'
require_relative 'administrate/models/account'
require_relative 'administrate/models/user'
require_relative 'administrate/models/webhook'
require_relative 'administrate/models/api_token'
require_relative 'administrate/models/client_model'
require_relative 'administrate/models/instance'
require_relative 'administrate/models/workflow'
require_relative 'administrate/models/execution'
require_relative 'administrate/models/sync_run'
require_relative 'administrate/models/llm_provider'
require_relative 'administrate/models/llm_project'
require_relative 'administrate/models/llm_cost'
require_relative 'administrate/transport'
require_relative 'administrate/cursor_iterator'
require_relative 'administrate/resources/base_resource'
require_relative 'administrate/resources/account'
require_relative 'administrate/resources/users'
require_relative 'administrate/resources/webhooks'
require_relative 'administrate/resources/api_tokens'
require_relative 'administrate/resources/clients'
require_relative 'administrate/resources/instances'
require_relative 'administrate/resources/workflows'
require_relative 'administrate/resources/executions'
require_relative 'administrate/resources/sync_runs'
require_relative 'administrate/resources/llm_providers'
require_relative 'administrate/resources/llm_projects'
require_relative 'administrate/resources/llm_costs'
require_relative 'administrate/client'

module Administrate
  def self.new(**kwargs)
    Client.new(**kwargs)
  end
end
