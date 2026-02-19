# frozen_string_literal: true

module Administrate
  module Resources
    class SyncRuns < BaseResource
      def list(instance_id: nil, client_id: nil, sync_type: nil, status: nil,
               start_date: nil, end_date: nil, page: nil, per_page: nil)
        params = {}
        params[:instance_id] = instance_id unless instance_id.nil?
        params[:client_id] = client_id unless client_id.nil?
        params[:sync_type] = sync_type unless sync_type.nil?
        params[:status] = status unless status.nil?
        params[:start_date] = start_date unless start_date.nil?
        params[:end_date] = end_date unless end_date.nil?
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'sync_runs', model: Models::SyncRun, params: params)
      end

      def get(sync_run_id)
        get_resource("sync_runs/#{sync_run_id}", Models::SyncRun)
      end

      def health
        response = @transport.get('sync_health')
        (response.body['data'] || []).map { |item| Models::SyncHealthEntry.new(item) }
      end
    end
  end
end
