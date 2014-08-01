require 'spec_helper'

describe Dataly::Reporter do

  let(:formatter) { Dataly::ReportFormatter.new }
  let(:reporter) { Dataly::Reporter.new('some_file', formatter) }

  context 'reporting processed' do
    before do
      reporter.processed('data')
    end
    let(:expected_rows_processed) { 1 }
    specify { expect(reporter.rows_read).to eq(expected_rows_processed) }
  end

  context 'reporting failed' do
    before do
      reporter.failed('error', 'data')
    end
    specify { expect(reporter.errors).to include({ error: 'error', data: 'data' }) }
  end

  context 'displaying report' do
    before do
      reporter.processed('data')
    end
    let(:expected_rows_processed) { 1 }
    it 'processes the results using the formatter' do
      expect(formatter).to receive(:process).with('some_file', expected_rows_processed, []).and_call_original
      reporter.output
    end
  end

end
