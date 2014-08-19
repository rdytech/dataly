class Dataly::BatchCreator < Dataly::Creator
  attr_reader :count, :batch

  def initialize(model, context = {}, count = 10)
    @model = model
    @batch = []
    @count = count
  end

  def save!(attributes)
    model.new(attributes).save!
  end

  def create(attributes, options = {})
    batch << attributes

    if batch.length == count
      model.transaction do
        drain
      end
    end
  end

  def drain
    batch.each do |attributes|
      save!(attributes)
    end

    @batch = []
  end
end
