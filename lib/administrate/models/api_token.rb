# frozen_string_literal: true

module Administrate
  module Models
    class ApiTokenCreatedBy < BaseModel
      attribute :id, :name
    end

    class ApiToken < BaseModel
      attribute :id, :name, :permission, :permission_label, :token_hint,
                :ip_allowlist, :last_used_at, :expires_at, :revoked, :active,
                :token, :created_at, :updated_at
      nested :created_by, ApiTokenCreatedBy
    end
  end
end
