class Dataly::Reporting::RowError
  attr_reader :data
  attr_reader :message

  def initialize(message, data = nil)
    @data = data
    @message = message
  end
end
