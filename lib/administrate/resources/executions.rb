# frozen_string_literal: true

module Administrate
  module Resources
    class Executions < BaseResource
      def list(client_id: nil, instance_id: nil, workflow_id: nil, status: nil,
               error_category: nil, start_date: nil, end_date: nil, errors_only: nil,
               page: nil, per_page: nil)
        params = {}
        params[:client_id] = client_id unless client_id.nil?
        params[:instance_id] = instance_id unless instance_id.nil?
        params[:workflow_id] = workflow_id unless workflow_id.nil?
        params[:status] = status unless status.nil?
        params[:error_category] = error_category unless error_category.nil?
        params[:start_date] = start_date unless start_date.nil?
        params[:end_date] = end_date unless end_date.nil?
        params[:errors_only] = errors_only.to_s unless errors_only.nil?
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'executions', model: Models::Execution, params: params)
      end

      def get(execution_id)
        get_resource("executions/#{execution_id}", Models::Execution)
      end
    end
  end
end
