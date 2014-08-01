class Dataly::Reporter
  attr_reader :formatter, :errors, :rows_read, :filename

  def initialize(filename, formatter = nil)
    @formatter = formatter || Dataly::ReportFormatter.new
    @errors = []
    @rows_read = 0
    @filename = filename
  end

  def output
    formatter.process(filename, rows_read, errors).output
  end

  def failed(error, data = nil)
    @errors << { error: error, data: data }
    row_read
  end

  def processed(data)
    row_read
  end

  private
  def row_read
    @rows_read = @rows_read + 1
  end
end
