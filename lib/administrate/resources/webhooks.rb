# frozen_string_literal: true

module Administrate
  module Resources
    class Webhooks < BaseResource
      def list(page: nil, per_page: nil)
        params = {}
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'webhooks', model: Models::Webhook, params: params)
      end

      def get(webhook_id)
        get_resource("webhooks/#{webhook_id}", Models::Webhook)
      end

      def create(url:, events:, description: nil, enabled: nil)
        body = { url: url, events: events }
        body[:description] = description unless description.nil?
        body[:enabled] = enabled unless enabled.nil?
        create_resource('webhooks', Models::Webhook, body)
      end

      def update(webhook_id, url: nil, events: nil, description: nil, enabled: nil)
        body = {}
        body[:url] = url unless url.nil?
        body[:events] = events unless events.nil?
        body[:description] = description unless description.nil?
        body[:enabled] = enabled unless enabled.nil?
        update_resource("webhooks/#{webhook_id}", Models::Webhook, body)
      end

      def delete(webhook_id)
        delete_resource("webhooks/#{webhook_id}")
      end

      def regenerate_secret(webhook_id)
        response = @transport.post("webhooks/#{webhook_id}/regenerate_secret")
        Models::Webhook.new(response.body['data'])
      end
    end
  end
end
