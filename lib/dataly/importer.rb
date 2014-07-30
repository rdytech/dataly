module Dataly
  class Importer
    attr_reader :reporter

    class_attribute :model

    def self.model(model)
      self.model = model
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
      @errors = options[:errors]
      @mapper = options.fetch(:mapper, Dataly::Mapper.new(@model))
      @creator = options.fetch(:creator, Dataly::Creator.new(@model))
      @reporter = options.fetch(:reporter, Dataly::Reporter.new(filename))
    end

    def process
      csv.each do |row|
        data = mapper.process(row)
        process_create(data)
      end

      reporter.report
    end

    def process_create(data)
      begin
        creator.create(data)
        reporter.processed(data)
      rescue Exception => e
        reporter.failed(e, data)
        raise e if fail_fast?
      end
    end

    def fail_fast?
      @errors == :raise
    end

    def csv
      CSV.read(@filename, { headers: true, encoding: 'utf-8' })
    end
  end
end
