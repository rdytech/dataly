require 'spec_helper'

class Sample
end

describe Dataly::Creator do

  let(:creator) { described_class.new(Sample) }

  before do
    allow(Sample).to receive(:new).and_return(double(:sample, save!: true))
  end

  it 'creates an instance of the model class' do
    expect(Sample).to receive(:new).and_return(double(:sample, save!: true))
    creator.create({})
  end
end
