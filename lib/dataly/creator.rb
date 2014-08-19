module Dataly
  class Creator
    attr_reader :model
    attr_reader :context

    def initialize(model, context = {})
      @model = model
      @context = context
    end

    def create(attributes, options = {})
      save_options = options.fetch(:save_options, nil)
      model.new(attributes).save!(save_options)
    end
  end
end
