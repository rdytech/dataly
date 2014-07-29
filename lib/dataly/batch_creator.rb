class Dataly::BatchCreator < Dataly::Creator
  attr_reader :count, :batch

  def initialize(model, count=10)
    @model = model
    @count = count
    @batch = []
  end

  def save!(attributes)
    model.new(attributes).save!
  end

  def create(attributes)
    batch << row

    if batch.length == count
      drain
    end
  end

  def drain
    batch.each do |attributes|
      save!(attributes)
    end

    @batch = []
  end
end
