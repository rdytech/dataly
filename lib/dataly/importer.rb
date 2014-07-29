module Dataly
  class Importer

    def self.model(model)
      @model = model
    end

    def model
      self.class.instance_variable_get(:@model)
    end

    def mapper
      @mapper ||= @default_mapper.new(model)
    end

    def creator
      @creator ||= @default_creator.new(model)
    end

    def initialize(filename, options = {})
      @filename = filename
      @model = self.model
      @errors = options.fetch(:errors, :log)
      @default_mapper = options.fetch(:default_mapper, Mapper)
      @default_creator = options.fetch(:default_creator, Dataly::Creator)
    end

    def process
      csv.each do |row|
        data = mapper.process(row)
        begin
          creator.create(data)
        rescue Exception => e
          logger.error(e.message)
          raise e if errors === :raise
        end
      end
    end

    def csv
      CSV.read(@filename, headers: true)
    end
  end
end
