module Dataly
  class FileSplitter
    attr_reader :filename, :count

    def initialize(filename, count=1000)
      @filename = filename
      @count = count
    end

    def next
      yield files.next
    end

    def files
      @file ||= create
    end

    def create
      header = File.open(filename, &:readline)
      split

      files = Dir.glob("#{directory}/*")
      append_header(files, header)

      files
    end

    def append_header(files, header)
      files.each do |f|
        `sed -i '1i#{header}' #{f}`
      end
    end

    def split
      `split -l #{count} #{filename}`
    end

    def directory
      @directory ||= Dir.mktmpdir('imports')
    end
  end
end
