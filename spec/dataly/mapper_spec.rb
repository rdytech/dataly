require 'spec_helper'

class Sample
end

describe Dataly::Mapper do

  let(:valid_attributes) { %w(name status address) }
  let(:mapper) { described_class.new(Sample) }

  let(:row) do
    {
      name: 'beaker',
      status: 'Active',
      age: 21,
      address: ''
    }
  end

  before do
    allow(Sample).to receive(:attribute_names).and_return(valid_attributes)
  end

  specify { expect(mapper.process(row)).to eq({ name: 'beaker', status: 'Active', address: nil }) }
end
