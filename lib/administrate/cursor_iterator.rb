# frozen_string_literal: true

module Administrate
  class CursorIterator
    include Enumerable

    def initialize(transport:, path:, model:, params: {})
      @transport = transport
      @path = path
      @model = model
      @params = params.dup
      @start_page = @params.delete(:page) || 1
    end

    def each(&block)
      page_num = @start_page
      loop do
        page = fetch_page(page_num)
        page.data.each(&block)
        break unless page.more?

        page_num += 1
      end
    end

    def first_page
      fetch_page(@start_page)
    end

    private

    def fetch_page(page_num)
      params = @params.merge(page: page_num)
      response = @transport.get(@path, params)
      body = response.body
      data = (body['data'] || []).map { |item| @model.new(item) }
      meta = Models::PaginationMeta.new(body['meta'] || {})
      Page.new(data: data, meta: meta)
    end
  end
end
