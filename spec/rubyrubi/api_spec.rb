require 'yaml'
require 'spec_helper'

describe Rubyrubi::API do

  let(:app_id) do
    YAML.load_file(File.expand_path('./spec/spec_config.yml', Dir.pwd))['api_key']
  end

  let(:text) do
    '青い空、白い雲'
  end

  let(:instance) do
    described_class
  end

  let(:response) do
    Hash.from_xml(File.read(File.expand_path('./spec/responce.xml', Dir.pwd))).to_json
  end

  it 'is exist' do
    expect(instance).not_to be nil
  end

  describe '#request' do
    it 'returns xml' do
      expect(instance.request(app_id, text).to_json).to eq response
    end
  end
end


