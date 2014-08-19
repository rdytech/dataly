module Dataly
  class JsonFormatter
    def output
      JSON.generate({
        filename: filename,
        rows: rows_read,
        errors: errors
      })
    end
  end
end
