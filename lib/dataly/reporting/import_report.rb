module Dataly::Reporting
  class ImportReport
    attr_reader :filename, :errors, :total_rows

    def initialize(filename, total_rows, errors)
      @filename = filename
      @total_rows = total_rows
      @errors = errors
    end


    def to_s
      report = <<"END_OF_REPORT"
Total rows imported : #{@total_rows}
------------------------------------

Errors:
#{@errors.each { |error| error.message }}

END_OF_REPORT
      report
    end

  end
end