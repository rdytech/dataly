module Dataly
  class Creator
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def create(attributes, skip_validations = nil)
      save_options= skip_validations ? { validate: false } : {}
      model.new(attributes).save!(save_options)
    end
  end
end
