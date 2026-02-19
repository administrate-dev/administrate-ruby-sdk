# frozen_string_literal: true

module Administrate
  module Resources
    class Clients < BaseResource
      def list(page: nil, per_page: nil)
        params = {}
        params[:page] = page unless page.nil?
        params[:per_page] = per_page unless per_page.nil?
        list_resource(path: 'clients', model: Models::Client, params: params)
      end

      def get(client_id)
        get_resource("clients/#{client_id}", Models::Client)
      end

      def create(name:, code: nil, notes: nil, timezone: nil, contact_first_name: nil,
                 contact_last_name: nil, contact_email: nil, contact_phone: nil)
        body = { name: name }
        body[:code] = code unless code.nil?
        body[:notes] = notes unless notes.nil?
        body[:timezone] = timezone unless timezone.nil?
        body[:contact_first_name] = contact_first_name unless contact_first_name.nil?
        body[:contact_last_name] = contact_last_name unless contact_last_name.nil?
        body[:contact_email] = contact_email unless contact_email.nil?
        body[:contact_phone] = contact_phone unless contact_phone.nil?
        create_resource('clients', Models::Client, body)
      end

      def update(client_id, name: nil, code: nil, notes: nil, timezone: nil,
                 contact_first_name: nil, contact_last_name: nil, contact_email: nil, contact_phone: nil)
        body = {}
        body[:name] = name unless name.nil?
        body[:code] = code unless code.nil?
        body[:notes] = notes unless notes.nil?
        body[:timezone] = timezone unless timezone.nil?
        body[:contact_first_name] = contact_first_name unless contact_first_name.nil?
        body[:contact_last_name] = contact_last_name unless contact_last_name.nil?
        body[:contact_email] = contact_email unless contact_email.nil?
        body[:contact_phone] = contact_phone unless contact_phone.nil?
        update_resource("clients/#{client_id}", Models::Client, body)
      end

      def delete(client_id)
        delete_resource("clients/#{client_id}")
      end
    end
  end
end
