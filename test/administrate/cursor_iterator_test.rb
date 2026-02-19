# frozen_string_literal: true

require 'test_helper'

class CursorIteratorTest < Minitest::Test
  include ApiTestHelper

  def setup
    @model_class = Class.new(Administrate::BaseModel) do
      attribute :id, :name
    end
  end

  def test_iterates_single_page
    stub_api(:get, 'items', body: paginated_response(
      [{ id: '1', name: 'A' }, { id: '2', name: 'B' }]
    ))

    iterator = Administrate::CursorIterator.new(transport: new_transport, path: 'items', model: @model_class)
    items = iterator.to_a

    assert_equal 2, items.size
    assert_equal '1', items[0].id
    assert_equal '2', items[1].id
  end

  def test_iterates_multiple_pages
    stub_request(:get, "#{API_BASE}/items")
      .with(query: hash_including('page' => '1'))
      .to_return(status: 200, body: paginated_response(
        [{ id: '1', name: 'A' }], page: 1, has_more: true, total: 2
      ).to_json, headers: { 'Content-Type' => 'application/json' })
    stub_request(:get, "#{API_BASE}/items")
      .with(query: hash_including('page' => '2'))
      .to_return(status: 200, body: paginated_response(
        [{ id: '2', name: 'B' }], page: 2, has_more: false, total: 2
      ).to_json, headers: { 'Content-Type' => 'application/json' })

    iterator = Administrate::CursorIterator.new(transport: new_transport, path: 'items', model: @model_class)
    items = iterator.to_a

    assert_equal 2, items.size
    assert_equal '1', items[0].id
    assert_equal '2', items[1].id
  end

  def test_handles_empty_results
    stub_api(:get, 'items', body: paginated_response([]))

    iterator = Administrate::CursorIterator.new(transport: new_transport, path: 'items', model: @model_class)
    items = iterator.to_a

    assert_empty items
  end

  def test_first_page
    stub_api(:get, 'items', body: paginated_response(
      [{ id: '1', name: 'A' }], page: 1, has_more: true, total: 2
    ))

    iterator = Administrate::CursorIterator.new(transport: new_transport, path: 'items', model: @model_class)
    page = iterator.first_page

    assert_instance_of Administrate::Page, page
    assert_equal 1, page.data.size
    assert page.more?
  end

  def test_supports_map
    stub_api(:get, 'items', body: paginated_response(
      [{ id: '1', name: 'A' }, { id: '2', name: 'B' }]
    ))

    iterator = Administrate::CursorIterator.new(transport: new_transport, path: 'items', model: @model_class)
    names = iterator.map(&:name)

    assert_equal %w[A B], names
  end

  def test_supports_select
    stub_api(:get, 'items', body: paginated_response(
      [{ id: '1', name: 'A' }, { id: '2', name: 'B' }]
    ))

    iterator = Administrate::CursorIterator.new(transport: new_transport, path: 'items', model: @model_class)
    filtered = iterator.select { |item| item.name == 'A' }

    assert_equal 1, filtered.size
    assert_equal 'A', filtered[0].name
  end
end
