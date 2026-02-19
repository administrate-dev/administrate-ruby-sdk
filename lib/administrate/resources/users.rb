# frozen_string_literal: true

module Administrate
  module Resources
    class Users < BaseResource
      def list(page: nil, per_page: nil)
        params = {}
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'users', model: Models::User, params: params)
      end

      def get(user_id)
        get_resource("users/#{user_id}", Models::User)
      end

      def invite(email:, role: nil)
        body = { email: email }
        body[:role] = role unless role.nil?
        response = @transport.post('users/invite', body)
        Models::Invitation.new(response.body['data'])
      end

      def update(user_id, role:)
        update_resource("users/#{user_id}", Models::User, { role: role })
      end

      def delete(user_id)
        delete_resource("users/#{user_id}")
      end
    end
  end
end
