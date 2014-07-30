module Dataly
  class Mapper
    attr_reader :model

    class << self
      def fields
        @fields ||= {}
      end

      def field(name, to: name, value: nil)
        fields[name] = { to: to, value: value }
      end
    end

    def fields
      self.class.fields
    end

    def initialize(model)
      @model = model
    end

    def process(row)
      row.map { |column| process_column(*column) }.compact.to_h
    end

    private
    def process_column(k, v)
      key = map_to(k)
      val = mapping_exists?(k) ? transform(k, v) : v
      val = blank_to_nil(val)

      return [key.to_sym, val] if attributes.include?(key.to_s)
    end

    def map_to(k)
      mapping_exists?(k) ? fields[k][:to] : k
    end

    def transform(csv_field_name, csv_value)
      transformer = fields[csv_field_name][:value]

      if transformer.respond_to?(:call)
        transformer.call(csv_value)
      elsif transformer && respond_to?(transformer)
        send(transformer, csv_value)
      else
        csv_value
      end
    end

    def mapping_exists?(key)
      fields[key].present?
    end

    def blank_to_nil(val)
      val.is_a?(String) && val.empty? ? nil : val
    end

    def attributes
      @attributes ||= model.attribute_names
    end
  end
end
