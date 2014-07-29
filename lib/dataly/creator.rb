module Dataly
  class Creator
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def create(attributes)
      model.new(attributes).save!
    end
  end
end
