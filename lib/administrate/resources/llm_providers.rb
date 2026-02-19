# frozen_string_literal: true

module Administrate
  module Resources
    class LlmProviders < BaseResource
      def list(page: nil, per_page: nil)
        params = {}
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'llm_providers', model: Models::LlmProvider, params: params)
      end

      def get(provider_id)
        get_resource("llm_providers/#{provider_id}", Models::LlmProvider)
      end

      def create(name:, provider_type:, api_key:, organization_id: nil, config: nil)
        body = {
          name: name,
          provider_type: provider_type,
          api_key: api_key
        }
        body[:organization_id] = organization_id unless organization_id.nil?
        body[:config] = config unless config.nil?
        create_resource('llm_providers', Models::LlmProvider, body)
      end

      def update(provider_id, name: nil, api_key: nil, organization_id: nil, config: nil)
        body = {}
        body[:name] = name unless name.nil?
        body[:api_key] = api_key unless api_key.nil?
        body[:organization_id] = organization_id unless organization_id.nil?
        body[:config] = config unless config.nil?
        update_resource("llm_providers/#{provider_id}", Models::LlmProvider, body)
      end

      def delete(provider_id)
        delete_resource("llm_providers/#{provider_id}")
      end

      def sync(provider_id)
        response = @transport.post("llm_providers/#{provider_id}/sync")
        response.body
      end
    end
  end
end
