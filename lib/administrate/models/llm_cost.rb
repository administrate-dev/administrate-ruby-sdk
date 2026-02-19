# frozen_string_literal: true

module Administrate
  module Models
    class LlmCostSummary < BaseModel
      attribute :total_cost_cents, :total_tokens, :total_input_tokens,
                :total_output_tokens, :total_requests, :providers_count
    end

    class LlmCostByProvider < BaseModel
      attribute :id, :name, :provider_type, :cost_cents, :tokens, :requests
    end

    class LlmCostByClient < BaseModel
      attribute :id, :name, :cost_cents, :tokens
    end

    class LlmCostModel < BaseModel
      attribute :model, :cost_cents, :tokens, :requests
    end

    class LlmCostDaily < BaseModel
      attribute :date, :cost_cents, :tokens
    end

    class LlmCostSummaryData < BaseModel
      nested :summary, LlmCostSummary
      nested :providers, LlmCostByProvider, array: true
      nested :models, LlmCostModel, array: true
      nested :daily, LlmCostDaily, array: true
    end

    class LlmCostSummaryMeta < BaseModel
      attribute :start_date, :end_date
    end
  end
end
