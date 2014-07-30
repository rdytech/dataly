require 'byebug'

module Dataly
  class Mapper
    attr_reader :model

    class_attribute :fields
    self.fields = {}

    def self.field(from, hash)
      fields[from] = hash
    end

    def initialize(model)
      @model = model
    end

    def process(row)
      row.map { |name, value|
        name, value = switch(name, value)
        [name.to_sym, (value.blank? ? nil : value)] if attributes.include?(name.to_s)
      }.compact.to_h
    end

    def switch(name, value)
      key = name.to_sym
      return [name, value] unless mapping_exists?(key)

      name = map_to(key, name)
      value = transform(key, value)

      [name, value]
    end

    def transform(name, value)
      transformer = map_value(name)
      return value unless transformer

      if transformer.respond_to?(:call)
        transformer.call(value)
      elsif respond_to?(transformer)
        send(transformer, value)
      else
        value
      end
    end

    def map_value(key)
      fields[key][:value]
    end

    def map_to(key, default)
      fields[key][:to] || default
    end

    def mapping_exists?(key)
      fields[key]
    end

    def attributes
      @model.attribute_names
    end

  end
end
