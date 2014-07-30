require 'spec_helper'

class Sample
end

class FieldMapper < Dataly::Mapper
  field :user, to: :user_id
  field :age, value: Proc.new { |value| value.to_i }
  field :status, value: :update_status

  def update_status(value)
    value.downcase
  end
end

class SecondFieldMapper < Dataly::Mapper
  field :user_2, to: :user_id
end

describe Dataly::Mapper do
  let(:valid_attributes) { %w(name status address user_id age) }
  let(:mapper) { FieldMapper.new(Sample) }

  let(:row) do
    {
      name: 'beaker',
      status: 'Active',
      age: '21',
      pets: 'false',
      address: '',
      user: '1'
    }
  end

  before do
    allow(Sample).to receive(:attribute_names).and_return(valid_attributes)
  end

  specify { expect(mapper.process(row)).to eq({ name: 'beaker', address: nil, status: 'active', user_id: '1', age: 21 }) }
  specify { expect(mapper.fields.keys).to eq([:user, :age, :status]) }
end
