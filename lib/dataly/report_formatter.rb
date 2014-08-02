class Dataly::ReportFormatter
  attr_reader :filename, :errors, :rows_read

  def process(filename, rows_read, errors)
    @filename = filename
    @rows_read = rows_read
    @errors = errors
    self
  end

  def output
    report = "-" * 60
    report << "\nImported from: #{filename}\n"
    report << "Total rows read: #{rows_read}\n"
    report << "Total error rows: #{errors.length}\n"
    if errors.any?
      report << "\nErrors:\n"
      report << errors(&:inspect).join("\n")
    end
    report << "\n"
    report << "-" * 60
  end
end
