module Dataly
  class BatchImporter < Importer
    def process
      splitter.each do |file|
        drain(open(file))
      end
    end

    def splitter
      @spliiter ||= Dataly::FileSplitter.new(@filename)
    end
  end
end
