# frozen_string_literal: true

module Administrate
  module Models
    class LlmProviderMetrics < BaseModel
      attribute :total_cost_cents, :total_tokens, :total_requests
    end

    class LlmProvider < BaseModel
      attribute :id, :name, :provider_type, :organization_id,
                :projects_count, :sync_status, :last_synced_at,
                :last_sync_error, :created_at, :updated_at
      nested :metrics, LlmProviderMetrics
    end
  end
end
