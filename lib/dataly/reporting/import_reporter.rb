class Dataly::Reporting::ImportReporter
  attr_reader :errors, :total_rows, :filename
  #TODO All reporting and logging needs be abstracted out

  def initialize(filename)
    @errors = []
    @total_rows = 0
    @filename = filename
  end

  def report
    Dataly::Reporting::ImportReport.new(filename, total_rows, errors)
  end

  def report_error(error, data = nil)
    @errors << Dataly::Reporting::RowError.new(error, data)
  end

  def row_added
    @total_rows = @total_rows + 1
  end
end
