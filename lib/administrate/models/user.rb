# frozen_string_literal: true

module Administrate
  module Models
    class User < BaseModel
      attribute :id, :email, :name, :first_name, :last_name,
                :phone, :timezone, :avatar_url, :role, :joined_at
    end

    class Invitation < BaseModel
      attribute :id, :email, :role, :expires_at, :created_at
    end
  end
end
