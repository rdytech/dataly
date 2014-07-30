class Dataly::Reporter
  attr_reader :formatter, :errors, :total_rows, :filename

  def initialize(filename, formatter = nil)
    @formatter = formatter || Dataly::ReportFormatter.new
    @errors = []
    @total_rows = 0
    @filename = filename
  end

  def report
    formatter.process(filename, total_rows, errors)
  end

  def failed(error, data = nil)
    @errors << Dataly::RowError.new(error, data)
  end

  def success(data)
    row_added
  end

  def row_added
    @total_rows = @total_rows + 1
  end
end
