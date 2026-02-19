# frozen_string_literal: true

module Administrate
  module Models
    class Webhook < BaseModel
      attribute :id, :url, :description, :events, :enabled,
                :consecutive_failures, :last_triggered_at, :secret,
                :created_at, :updated_at
    end
  end
end
