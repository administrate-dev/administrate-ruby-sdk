# frozen_string_literal: true

module Administrate
  module Models
    class InstanceMetrics < BaseModel
      attribute :executions_count, :success_rate
    end

    class Instance < BaseModel
      attribute :id, :service_type, :company_id, :company_name, :name, :base_url,
                :workflows_count, :sync_status, :last_synced_at,
                :last_workflows_synced_at, :last_executions_synced_at,
                :last_sync_error, :created_at, :updated_at
      nested :metrics, InstanceMetrics
    end
  end
end
