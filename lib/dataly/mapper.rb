module Dataly
  class Mapper
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def process(row)
      row.map { |name, value|
        [name.to_sym, (value.blank? ? nil : value)] if attributes.include?(name.to_s)
      }.compact.to_h
    end


    def attributes
      @model.attribute_names
    end

  end
end
