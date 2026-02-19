# frozen_string_literal: true

require 'test_helper'

class BaseModelTest < Minitest::Test
  def setup
    @test_class = Class.new(Administrate::BaseModel) do
      attribute :id, :name, :status
    end

    @child_class = Class.new(Administrate::BaseModel) do
      attribute :value, :label
    end

    child = @child_class
    @parent_class = Class.new(Administrate::BaseModel) do
      attribute :id
      nested :child, child
      nested :items, child, array: true
    end
  end

  def test_defines_attr_readers
    model = @test_class.new(id: '1', name: 'Test', status: 'active')
    assert_equal '1', model.id
    assert_equal 'Test', model.name
    assert_equal 'active', model.status
  end

  def test_handles_missing_attributes_as_nil
    model = @test_class.new(id: '1')
    assert_nil model.name
    assert_nil model.status
  end

  def test_handles_string_keys
    model = @test_class.new('id' => '1', 'name' => 'Test')
    assert_equal '1', model.id
    assert_equal 'Test', model.name
  end

  def test_deserializes_nested_hashes
    model = @parent_class.new(id: '1', child: { value: 'a', label: 'A' })
    assert_instance_of @child_class, model.child
    assert_equal 'a', model.child.value
    assert_equal 'A', model.child.label
  end

  def test_deserializes_nested_arrays
    model = @parent_class.new(
      id: '1',
      items: [{ value: 'a', label: 'A' }, { value: 'b', label: 'B' }]
    )
    assert_instance_of Array, model.items
    assert_equal 2, model.items.size
    assert_equal 'a', model.items[0].value
    assert_equal 'b', model.items[1].value
  end

  def test_handles_nil_nested_values
    model = @parent_class.new(id: '1', child: nil)
    assert_nil model.child
  end

  def test_stores_unknown_keys_in_extra
    model = @test_class.new(id: '1', name: 'Test', unknown_field: 'extra_value')
    assert_equal 'extra_value', model.extra[:unknown_field]
  end

  def test_bracket_access_for_known_attributes
    model = @test_class.new(id: '1')
    assert_equal '1', model[:id]
  end

  def test_bracket_access_for_extra_fields
    model = @test_class.new(id: '1', unknown_field: 'extra_value')
    assert_equal 'extra_value', model[:unknown_field]
  end

  def test_to_h_returns_hash
    model = @test_class.new(id: '1', name: 'Test', status: 'active')
    assert_equal({ id: '1', name: 'Test', status: 'active' }, model.to_h)
  end

  def test_to_h_includes_extra_fields
    model = @test_class.new(id: '1', extra_field: 'val')
    hash = model.to_h
    assert_equal 'val', hash[:extra_field]
  end

  def test_to_h_serializes_nested_models
    model = @parent_class.new(id: '1', child: { value: 'a', label: 'A' })
    hash = model.to_h
    assert_equal({ value: 'a', label: 'A' }, hash[:child])
  end

  def test_equality
    a = @test_class.new(id: '1', name: 'Test')
    b = @test_class.new(id: '1', name: 'Test')
    assert_equal a, b
  end

  def test_inequality
    a = @test_class.new(id: '1', name: 'Test')
    b = @test_class.new(id: '2', name: 'Other')
    refute_equal a, b
  end

  def test_inspect
    model = @test_class.new(id: '1', name: 'Test')
    assert_includes model.inspect, 'id="1"'
    assert_includes model.inspect, 'name="Test"'
  end
end
