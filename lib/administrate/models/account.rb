# frozen_string_literal: true

module Administrate
  module Models
    class TokenInfo < BaseModel
      attribute :name, :permission, :expires_at
    end

    class AccountInfo < BaseModel
      attribute :id, :name, :plan
    end

    class MeResponse < BaseModel
      nested :token, TokenInfo
      nested :account, AccountInfo
    end

    class Account < BaseModel
      attribute :id, :name, :slug, :billing_email, :phone, :timezone,
                :logo_url, :plan, :plan_name, :on_trial, :trial_ends_at,
                :usage, :created_at, :updated_at
    end
  end
end
