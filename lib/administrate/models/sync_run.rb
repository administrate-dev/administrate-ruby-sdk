# frozen_string_literal: true

module Administrate
  module Models
    class SyncRun < BaseModel
      attribute :id, :instance_id, :instance_name, :sync_type, :status,
                :started_at, :finished_at, :duration_seconds,
                :records_created, :records_updated, :error_message, :created_at
    end

    class SyncHealthSyncInfo < BaseModel
      attribute :last_synced_at
      nested :last_run, SyncRun
    end

    class SyncHealthEntry < BaseModel
      attribute :instance_id, :instance_name, :client_id, :client_name,
                :sync_status, :last_sync_error
      nested :workflows, SyncHealthSyncInfo
      nested :executions, SyncHealthSyncInfo
    end
  end
end
