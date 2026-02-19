# frozen_string_literal: true

module Administrate
  module Resources
    class LlmProjects < BaseResource
      def list(provider_id, page: nil, per_page: nil)
        params = {}
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: "llm_providers/#{provider_id}/llm_projects", model: Models::LlmProject, params: params)
      end

      def update(provider_id, project_id, client_id: nil)
        body = {}
        body[:client_id] = client_id unless client_id.nil?
        update_resource("llm_providers/#{provider_id}/llm_projects/#{project_id}", Models::LlmProject, body)
      end
    end
  end
end
