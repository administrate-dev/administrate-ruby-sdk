# frozen_string_literal: true

module Administrate
  module Models
    class PaginationMeta < BaseModel
      attribute :page, :per_page, :total, :total_pages, :has_more
    end
  end
end
