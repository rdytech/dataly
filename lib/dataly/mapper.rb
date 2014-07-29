module Dataly
  class Mapper
    attr_reader :model

    class_attribute :fields
    self.fields = {}

    def self.field(from, symbol_or_proc)
      fields[from] = symbol_or_proc
    end

    def initialize(model)
      @model = model
    end

    def process(row)
      row.map { |name, value|
        name = switch(name, value)
        value = transform(name, value)
        [name.to_sym, (value.blank? ? nil : value)] if attributes.include?(name.to_s)
      }.compact.to_h
    end

    def switch(name, value)
      fields[name] || name
    end

    def transform(name, value)
      if fields[name.to_sym].respond_to?(:call)
        fields[name.to_sym].call(value)
      else
        value
      end
    end

    def attributes
      @model.attribute_names
    end

  end
end
