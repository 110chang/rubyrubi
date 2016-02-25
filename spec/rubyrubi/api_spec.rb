require 'yaml'
require 'spec_helper'

describe Rubyrubi::API do

  def load_fixture(path)
    Hash.from_xml(File.read(File.expand_path(path, Dir.pwd))).to_json
  end

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
    load_fixture('./spec/fixtures/api_responce_1.xml')
  end

  it 'is exist' do
    expect(instance).not_to be nil
  end

  describe '#request' do

    # http://jlp.yahooapis.jp/MAService/V1/parse?appid=APP_ID-&filter=1%7C2%7C3%7C4%7C5%7C6%7C7%7C8%7C9%7C10%7C11%7C12%7C13&ma_response=surface%2Creading%2Cpos%2Cfeature&results=ma&sentence=%E9%9D%92%E3%81%84%E7%A9%BA%E3%80%81%E7%99%BD%E3%81%84%E9%9B%B2
    it 'xmlが返る' do
      expect(instance.request(app_id, text).to_json).to eq response
    end

    # http://jlp.yahooapis.jp/MAService/V1/parse?appid=APP_ID-&filter=1%7C2%7C3%7C4%7C5%7C6%7C7%7C8%7C9%7C10%7C11%7C12%7C13&ma_response=surface%2Creading%2Cpos%2Cfeature&results=ma&sentence=%E9%80%B2%E7%A0%94%E3%82%BC%E3%83%9F
    it 'xmlが返る(固名商品)' do
      text = '進研ゼミ'
      response = load_fixture('./spec/fixtures/api_responce_2.xml')
      expect(instance.request(app_id, text).to_json).to eq response
    end

    # http://jlp.yahooapis.jp/MAService/V1/parse?appid=APP_ID-&filter=1%7C2%7C3%7C4%7C5%7C6%7C7%7C8%7C9%7C10%7C11%7C12%7C13&ma_response=surface%2Creading%2Cpos%2Cfeature&results=ma&sentence=%E3%82%B8%E3%83%A3%E3%83%B3%EF%BC%9D%E3%82%B8%E3%83%A3%E3%83%83%E3%82%AF%E3%83%BB%E3%83%AB%E3%82%BD%E3%83%BC
    it 'xmlが返る(固有名詞)' do
      text = 'ジャン＝ジャック・ルソー'
      response = load_fixture('./spec/fixtures/api_responce_3.xml')
      expect(instance.request(app_id, text).to_json).to eq response
    end

    # http://jlp.yahooapis.jp/MAService/V1/parse?appid=APP_ID-&filter=1%7C2%7C3%7C4%7C5%7C6%7C7%7C8%7C9%7C10%7C11%7C12%7C13&ma_response=surface%2Creading%2Cpos%2Cfeature&results=ma&sentence=%E4%BD%BF%E3%81%84%E6%96%B9
    it '「使い方」は名詞として帰ってくる' do
      text = '使い方'
      response = load_fixture('./spec/fixtures/api_responce_4.xml')
      expect(instance.request(app_id, text).to_json).to eq response
    end
  end
end

