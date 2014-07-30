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
    @errors << { error: error, data: data }
  end

  def processed(data)
    row_added
  end

  private
  def row_added
    @total_rows = @total_rows + 1
  end
end
