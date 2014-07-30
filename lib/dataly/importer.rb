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
      @import_reporter = Dataly::Reporting::ImportReporter.new(filename)
    end

    def process
      csv.each do |row|
        data = mapper.process(row)
        process_create(data)
        @import_reporter.row_added()
      end
      @import_reporter.report
    end

    def process_create(data)
      begin
        creator.create(data)
      rescue Exception => e
        create_failed!(e, data)
      end
    end

    def create_failed!(e, data)
      logger.error(data)
      logger.error(e.message)
      @import_reporter.report_error(e, data)
      raise e if errors === :raise
    end

    def csv
      CSV.read(@filename, { headers: true, encoding: 'utf-8' })
    end
  end
end
