require 'spec_helper'

class Sample
end

class SampleMapper < Dataly::Mapper
  field :age, value: Proc.new { |value| value.to_i }

  def attributes
    %i(name status age)
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
    f.write "name,status,age\n"
    f.write "Jack Bauer,active,10\n"
  end
end

describe Dataly::Importer do
  include FakeFS::SpecHelpers

  let(:reporter) { instance_double(Dataly::Reporter) }
  let(:importer) { SampleImporter.new('sample.csv', { reporter: Dataly::Reporter }) }
  let(:sample_file) { double(:sample) }

  before do
    create_sample_csv('sample.csv')
    allow(Dataly::Reporter).to receive(:new).and_return(reporter)
    allow(reporter).to receive(:processed)
    allow(Sample).to receive(:new).and_return(sample_file)
    allow(sample_file).to receive(:save!).and_return(true)
  end

  it 'creates an instance of the importers model for each row' do
    expect(Sample).to receive(:new).with({ name: "Jack Bauer",
      status: "active",
      age: 10
    })
    importer.process
  end
  context 'Default notification' do
    it 'adds successful row from import to report' do
      expect(reporter).to receive(:processed)
      importer.process
    end

    it 'adds unsuccessful rows to report' do
      allow(sample_file).to receive(:save!).and_raise(StandardError)
      expect(reporter).to receive(:failed)
      importer.process
    end

    it 'returns the reporter' do
      expect(importer.process).to eql(reporter)
    end

  end
  context 'Error notification to raise' do
    let(:importer) do
      SampleImporter.new('sample.csv',
        { errors: raise })
    end
    let(:sample) { Sample.new }

    before do
      allow(reporter).to receive(:failed)
      allow(sample_file).to receive(:save!).and_raise(StandardError)
    end

    it 'raises an exception' do
      expect { importer.process }.to raise_error(StandardError)
    end
  end
end
