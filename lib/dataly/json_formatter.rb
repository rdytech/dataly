module Dataly
  class JsonFormatter < ReportFormatter
    def output
      JSON.generate({
        filename: filename,
        rows: rows_read,
        errors: error_hash
      })
    end

    def error_hash
      errors.collect do |error|
        {error: error[:error].to_s,
         data: error[:data] }
      end
    end
  end
end
