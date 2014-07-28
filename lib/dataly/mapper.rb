class Mapper
  attr_reader :model

  def initialize(model)
    @model = model
  end

  def process(row)
    row.collect { |entry| attributes.include?(entry) }
  end

  def attributes
    @model.attribute_names
  end
end
