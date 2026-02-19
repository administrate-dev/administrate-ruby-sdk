# frozen_string_literal: true

module Administrate
  module Models
    class WorkflowMetrics < BaseModel
      attribute :executions_count, :success_count, :failure_count,
                :success_rate, :time_saved_minutes
    end

    class Workflow < BaseModel
      attribute :id, :instance_id, :instance_name, :company_id, :company_name,
                :external_workflow_id, :name, :is_active,
                :minutes_saved_per_success, :minutes_saved_per_failure,
                :created_at, :updated_at
      nested :metrics, WorkflowMetrics
    end
  end
end
