# frozen_string_literal: true

module Administrate
  module Resources
    class LlmCosts < BaseResource
      def summary(start_date: nil, end_date: nil)
        response = @transport.get('llm_costs', date_params(start_date, end_date))
        body = response.body
        LlmCostSummaryResponse.new(
          data: Models::LlmCostSummaryData.new(body['data']),
          meta: Models::LlmCostSummaryMeta.new(body['meta'])
        )
      end

      def by_client(start_date: nil, end_date: nil)
        response = @transport.get('llm_costs/by_client', date_params(start_date, end_date))
        body = response.body
        LlmCostByClientResponse.new(
          data: (body['data'] || []).map { |item| Models::LlmCostByClient.new(item) },
          meta: Models::LlmCostSummaryMeta.new(body['meta'])
        )
      end

      def by_provider(start_date: nil, end_date: nil)
        response = @transport.get('llm_costs/by_provider', date_params(start_date, end_date))
        body = response.body
        LlmCostByProviderResponse.new(
          data: (body['data'] || []).map { |item| Models::LlmCostByProvider.new(item) },
          meta: Models::LlmCostSummaryMeta.new(body['meta'])
        )
      end

      private

      def date_params(start_date, end_date)
        params = {}
        params[:start_date] = start_date unless start_date.nil?
        params[:end_date] = end_date unless end_date.nil?
        params
      end
    end

    class LlmCostSummaryResponse
      attr_reader :data, :meta

      def initialize(data:, meta:)
        @data = data
        @meta = meta
      end
    end

    class LlmCostByClientResponse
      attr_reader :data, :meta

      def initialize(data:, meta:)
        @data = data
        @meta = meta
      end
    end

    class LlmCostByProviderResponse
      attr_reader :data, :meta

      def initialize(data:, meta:)
        @data = data
        @meta = meta
      end
    end
  end
end
