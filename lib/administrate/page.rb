# frozen_string_literal: true

module Administrate
  class Page
    attr_reader :data, :meta

    def initialize(data:, meta:)
      @data = data
      @meta = meta
    end

    def each(&)
      @data.each(&)
    end

    def size
      @data.size
    end
    alias length size

    def more?
      @meta.has_more
    end
  end
end
