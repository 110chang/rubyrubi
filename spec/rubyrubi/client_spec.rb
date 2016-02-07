require 'spec_helper'

describe Rubyrubi::Client do

  let(:app_id) do
    'dj0zaiZpPU01NnFBTDZLYVBkeiZzPWNvbnN1bWVyc2VjcmV0Jng9Njk-'
  end

  let(:instance) do
    described_class.new(app_id)
  end

  let(:text) do
    '青い空、白い雲'
  end

  let(:response) do
    Hash.from_xml(File.read(File.expand_path('./spec/responce.xml', Dir.pwd))).to_json
  end

  it 'is exist' do
    expect(instance).not_to be nil
  end

  describe '#furu' do
    it 'returns xml' do
      expect(instance.furu(text).to_json).to eq response
    end
  end
end

