# frozen_string_literal: true

module Administrate
  module Resources
    class BaseResource
      def initialize(transport)
        @transport = transport
      end

      private

      def list_resource(path:, model:, params: {})
        CursorIterator.new(transport: @transport, path: path, model: model, params: params)
      end

      def get_resource(path, model)
        response = @transport.get(path)
        model.new(response.body['data'])
      end

      def create_resource(path, model, body)
        response = @transport.post(path, body)
        model.new(response.body['data'])
      end

      def update_resource(path, model, body)
        response = @transport.patch(path, body)
        model.new(response.body['data'])
      end

      def delete_resource(path)
        @transport.delete(path)
        nil
      end
    end
  end
end
