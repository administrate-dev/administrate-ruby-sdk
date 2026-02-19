# frozen_string_literal: true

module Administrate
  module Resources
    class Instances < BaseResource
      def list(client_id: nil, service_type: nil, sync_status: nil, page: nil, per_page: nil)
        params = {}
        params[:company_id] = client_id unless client_id.nil?
        params[:service_type] = service_type unless service_type.nil?
        params[:sync_status] = sync_status unless sync_status.nil?
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'instances', model: Models::Instance, params: params)
      end

      def get(instance_id)
        get_resource("instances/#{instance_id}", Models::Instance)
      end

      def create(client_id:, name:, base_url:, api_key:, service_type: nil)
        body = {
          company_id: client_id,
          name: name,
          base_url: base_url,
          api_key: api_key
        }
        body[:service_type] = service_type unless service_type.nil?
        create_resource('instances', Models::Instance, body)
      end

      def update(instance_id, name: nil, base_url: nil, api_key: nil, service_type: nil)
        body = {}
        body[:name] = name unless name.nil?
        body[:base_url] = base_url unless base_url.nil?
        body[:api_key] = api_key unless api_key.nil?
        body[:service_type] = service_type unless service_type.nil?
        update_resource("instances/#{instance_id}", Models::Instance, body)
      end

      def delete(instance_id)
        delete_resource("instances/#{instance_id}")
      end

      def sync(instance_id, sync_type: nil)
        body = {}
        body[:sync_type] = sync_type unless sync_type.nil?
        response = @transport.post("instances/#{instance_id}/sync", body)
        response.body
      end

      def sync_all(sync_type: nil, client_id: nil, service_type: nil)
        body = {}
        body[:sync_type] = sync_type unless sync_type.nil?
        body[:company_id] = client_id unless client_id.nil?
        body[:service_type] = service_type unless service_type.nil?
        response = @transport.post('instances/sync_all', body)
        response.body
      end
    end
  end
end
