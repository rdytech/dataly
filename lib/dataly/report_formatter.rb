class Dataly::ReportFormatter
  attr_reader :filename, :errors, :total_rows

  def process(filename, total_rows, errors)
    @filename = filename
    @total_rows = total_rows
    @errors = errors
    self
  end

  def output
    report = "-" * 60
    report << "\nImported from: #{filename}\n"
    report << "Total rows imported: #{total_rows}\n"
    if errors.any?
      report << "\nErrors:\n"
      report << errors(&:inspect).join("\n")
    end
    report << "\n"
    report << "-" * 60
  end
end
