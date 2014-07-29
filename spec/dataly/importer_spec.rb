require 'spec_helper'

class Sample
end

class SampleMapper < Dataly::Mapper

  def attributes
    %w(name status)
  end
end


class SampleImporter < Dataly::Importer
  model Sample

  def mapper
    SampleMapper.new(model)
  end
end

def create_sample_csv(file)
  File.open(file, 'w') do |f|
    f.write "name,status\n"
    f.write "Jack Bauer,active\n"
  end
end

describe Dataly::Importer do
  include FakeFS::SpecHelpers

  let(:importer) { SampleImporter.new('sample.csv') }

  before do
    create_sample_csv('sample.csv')
    allow(Sample).to receive(:new).and_return(double(:sample, save!: true))
  end

  it 'creates an instance of the importers model for each row' do
    expect(Sample).to receive(:new).with({ name: "Jack Bauer",
                                           status: "active" })
    importer.process
  end

  context 'Error notification to raise' do
    let(:importer) do
      SampleImporter.new('sample.csv',
                         { errors: raise })
    end
    let(:sample) { Sample.new }

    before do
      allow(sample).to receive(:save!).and_raise(StandardError)
      allow(Sample).to receive(:new).and_return(sample)
    end

    it 'raises an exception' do
      expect { importer.process }.to raise_error(StandardError)
    end
  end
end
