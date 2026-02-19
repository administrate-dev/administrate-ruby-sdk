# frozen_string_literal: true

module Administrate
  class BaseModel
    class << self
      def attribute(*names)
        @attributes ||= []
        names.each do |name|
          @attributes << name.to_sym
          attr_reader name
        end
      end

      def nested(name, klass, array: false)
        @nested_fields ||= {}
        @nested_fields[name.to_sym] = { klass: klass, array: array }
        attr_reader name
      end

      def attributes
        @attributes || []
      end

      def nested_fields
        @nested_fields || {}
      end

      def inherited(subclass)
        super
        subclass.instance_variable_set(:@attributes, (attributes || []).dup)
        subclass.instance_variable_set(:@nested_fields, (nested_fields || {}).dup)
      end
    end

    attr_reader :extra

    def initialize(data = {})
      data = data.transform_keys(&:to_sym) if data.is_a?(Hash)
      known_keys = self.class.attributes + self.class.nested_fields.keys
      @extra = {}

      known_keys.each do |key|
        value = data[key]
        nested_config = self.class.nested_fields[key]

        if nested_config && !value.nil?
          value = if nested_config[:array]
                    Array(value).map { |item| item.is_a?(Hash) ? nested_config[:klass].new(item) : item }
                  elsif value.is_a?(Hash)
                    nested_config[:klass].new(value)
                  else
                    value
                  end
        end

        instance_variable_set(:"@#{key}", value)
      end

      data.each do |key, value|
        @extra[key] = value unless known_keys.include?(key.to_sym)
      end
    end

    def to_h
      result = {}
      (self.class.attributes + self.class.nested_fields.keys).each do |key|
        value = instance_variable_get(:"@#{key}")
        result[key] = serialize_value(value)
      end
      result.merge(@extra)
    end

    def [](key)
      key = key.to_sym
      if (self.class.attributes + self.class.nested_fields.keys).include?(key)
        instance_variable_get(:"@#{key}")
      else
        @extra[key]
      end
    end

    def ==(other)
      return false unless other.is_a?(self.class)

      to_h == other.to_h
    end

    def inspect
      attrs = (self.class.attributes + self.class.nested_fields.keys).map do |key|
        "#{key}=#{instance_variable_get(:"@#{key}").inspect}"
      end
      "#<#{self.class.name} #{attrs.join(', ')}>"
    end

    private

    def serialize_value(value)
      case value
      when BaseModel
        value.to_h
      when Array
        value.map { |item| serialize_value(item) }
      else
        value
      end
    end
  end
end
