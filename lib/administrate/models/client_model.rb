# frozen_string_literal: true

module Administrate
  module Models
    class ClientMetrics < BaseModel
      attribute :executions_count, :success_rate, :failure_count, :time_saved_minutes
    end

    class Client < BaseModel
      attribute :id, :name, :code, :notes, :timezone, :effective_timezone,
                :contact_first_name, :contact_last_name, :contact_email,
                :contact_phone, :n8n_instances_count, :created_at, :updated_at
      nested :metrics, ClientMetrics
    end
  end
end
