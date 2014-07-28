require 'csv'
class Importer

  def self.model(model)
    @model = model
  end

  def model
    self.class.instance_variable_get(:@model)
  end

  def mapper
    @mapper ||= Mapper.new(model)
  end

  def creator
    model
  end

  def initialize(filename)
    @filename = filename
    @model = self.model
  end

  def process
    csv.each do |row|
      data = mapper.process(row)
      creator.new(data).save!
    end
  end

  def csv
    CSV.read(@filename, headers: true)
  end
end
