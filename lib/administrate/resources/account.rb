# frozen_string_literal: true

module Administrate
  module Resources
    class Account < BaseResource
      def me
        response = @transport.get('me')
        Models::MeResponse.new(response.body)
      end

      def get
        get_resource('account', Models::Account)
      end

      def update(name: nil, billing_email: nil, timezone: nil)
        body = {}
        body[:name] = name unless name.nil?
        body[:billing_email] = billing_email unless billing_email.nil?
        body[:timezone] = timezone unless timezone.nil?
        update_resource('account', Models::Account, body)
      end
    end
  end
end
