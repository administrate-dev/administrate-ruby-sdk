# frozen_string_literal: true

module Administrate
  module Models
    class LlmProject < BaseModel
      attribute :id, :external_id, :name, :client_id, :client_name,
                :total_cost_cents, :total_tokens, :created_at, :updated_at
    end
  end
end
