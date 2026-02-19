# frozen_string_literal: true

module Administrate
  module Resources
    class ApiTokens < BaseResource
      def list(page: nil, per_page: nil)
        params = {}
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'api_tokens', model: Models::ApiToken, params: params)
      end

      def get(token_id)
        get_resource("api_tokens/#{token_id}", Models::ApiToken)
      end

      def create(name:, permission: nil, ip_allowlist: nil, expires_in: nil)
        body = { name: name }
        body[:permission] = permission unless permission.nil?
        body[:ip_allowlist] = ip_allowlist unless ip_allowlist.nil?
        body[:expires_in] = expires_in unless expires_in.nil?
        create_resource('api_tokens', Models::ApiToken, body)
      end

      def update(token_id, name: nil, ip_allowlist: nil)
        body = {}
        body[:name] = name unless name.nil?
        body[:ip_allowlist] = ip_allowlist unless ip_allowlist.nil?
        update_resource("api_tokens/#{token_id}", Models::ApiToken, body)
      end

      def delete(token_id)
        delete_resource("api_tokens/#{token_id}")
      end
    end
  end
end
