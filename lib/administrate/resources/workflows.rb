# frozen_string_literal: true

module Administrate
  module Resources
    class Workflows < BaseResource
      def list(client_id: nil, instance_id: nil, active: nil, search: nil, page: nil, per_page: nil)
        params = {}
        params[:company_id] = client_id unless client_id.nil?
        params[:instance_id] = instance_id unless instance_id.nil?
        params[:active] = active.to_s unless active.nil?
        params[:search] = search unless search.nil?
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'workflows', model: Models::Workflow, params: params)
      end

      def get(workflow_id)
        get_resource("workflows/#{workflow_id}", Models::Workflow)
      end

      def update(workflow_id, minutes_saved_per_success: nil, minutes_saved_per_failure: nil)
        body = {}
        body[:minutes_saved_per_success] = minutes_saved_per_success unless minutes_saved_per_success.nil?
        body[:minutes_saved_per_failure] = minutes_saved_per_failure unless minutes_saved_per_failure.nil?
        update_resource("workflows/#{workflow_id}", Models::Workflow, body)
      end
    end
  end
end
