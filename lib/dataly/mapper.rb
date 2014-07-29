require 'byebug'

module Dataly
  class Mapper
    attr_reader :model

    def self.field(from, name)
      fields[from] = name
    end

    def self.fields
      @@fields ||= {}
    end

    def initialize(model)
      @model = model
    end

    def process(row)
      row.map { |name, value|
        name = switch(name, value)
        [name.to_sym, (value.blank? ? nil : value)] if attributes.include?(name.to_s)
      }.compact.to_h
    end

    def switch(name, value)
      @@fields[name] || name
    end

    def attributes
      @model.attribute_names
    end

  end
end
