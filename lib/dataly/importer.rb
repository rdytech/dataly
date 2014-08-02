module Dataly
  class Importer
    attr_reader :reporter
    attr_reader :mapper
    attr_reader :creator
    attr_reader :context

    class_attribute :model

    def self.model(model)
      self.model = model
    end


    def initialize(filename, options = {})
      @filename = filename
      @model = options.fetch(:model, self.model)
      @errors = options[:errors]
      @context = options.fetch(:context, {})
      @mapper = options.fetch(:mapper, Dataly::Mapper).new(@model)
      @creator = options.fetch(:creator, Dataly::Creator).new(@model, context)
      @reporter = options.fetch(:reporter, Dataly::Reporter).new(filename)
      @create_options = { save_options: options.fetch(:save_options, {}) }
    end

    def process
      csv.each do |row|
        data = mapper.process(row)
        process_create(data)
      end

      reporter
    end

    def process_create(data)
      begin
        creator.create(data, @create_options)
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
      CSV.open(@filename, { headers: true, header_converters: :symbol, encoding: 'utf-8' })
    end
  end
end
