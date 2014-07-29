module Dataly
  class Importer
    attr_reader :logger, :errors

    class_attribute :model

    def self.model(model)
      self.model = model
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def mapper
      @mapper ||= @default_mapper.new(model)
    end

    def creator
      @creator ||= @default_creator.new(model)
    end

    def initialize(filename, options = {})
      @filename = filename
      @model = options[:model] || self.model
      @errors = options.fetch(:errors, :log)
      @default_mapper = options.fetch(:default_mapper, Mapper)
      @default_creator = options.fetch(:default_creator, Dataly::Creator)
    end

    def process
      csv.each do |row|
        data = mapper.process(row)
        process_create(data)
      end
    end

    def process_create(data)
      begin
        creator.create(data)
      rescue Exception => e
        create_failed!(e)
      end
    end

    def create_failed!(e)
      logger.error(e.message)
      raise e if errors === :raise
    end

    def csv
      CSV.read(@filename, { headers: true, encoding: 'utf-8' })
    end
  end
end
