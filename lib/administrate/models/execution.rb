# frozen_string_literal: true

module Administrate
  module Models
    class Execution < BaseModel
      attribute :id, :workflow_id, :workflow_name, :instance_id, :instance_name,
                :client_id, :client_name, :external_execution_id, :status,
                :started_at, :finished_at, :duration_ms, :duration_seconds,
                :error_category, :error_message, :error_payload, :created_at
    end
  end
end
