require 'spec_helper'

describe Rubyrubi::Parser::Base do

  let(:response) do
    Hash.from_xml(File.read(File.expand_path('./spec/responce.xml', Dir.pwd)))
  end

  let(:instance) do
    described_class.new(response)
  end

  it 'is exist' do
    expect(instance).not_to be nil
  end

  describe '#parse' do
    it 'returns new results' do
      markup = ["<ruby>青<rp>（</rp><rt>あお</rt><rp>）</rp></ruby>い",
       "<ruby>空<rp>（</rp><rt>そら</rt><rp>）</rp></ruby>",
       "、",
       "<ruby>白<rp>（</rp><rt>しろ</rt><rp>）</rp></ruby>い",
       "<ruby>雲<rp>（</rp><rt>くも</rt><rp>）</rp></ruby>"]
      expect(instance.parse()).to eq markup
    end
    it '“大きな空”を変換' do
      instance = described_class.new(Hash.from_xml('<?xml version="1.0" encoding="UTF-8" ?><ResultSet xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="urn:yahoo:jp:jlp" xsi:schemaLocation="urn:yahoo:jp:jlp http://jlp.yahooapis.jp/MAService/V1/parseResponse.xsd"><ma_result><total_count>2</total_count><filtered_count>2</filtered_count><word_list><word><surface>大きな</surface><reading>おおきな</reading><pos>連体詞</pos></word><word><surface>空</surface><reading>そら</reading><pos>名詞</pos></word></word_list></ma_result><uniq_result><total_count>2</total_count><filtered_count>2</filtered_count><word_list><word><count>1</count><surface>大きな</surface><reading/><pos>連体詞</pos></word><word><count>1</count><surface>空</surface><reading/><pos>名詞</pos></word></word_list></uniq_result></ResultSet>'))
      markup = ["<ruby>大<rp>（</rp><rt>おお</rt><rp>）</rp></ruby>きな",
       "<ruby>空<rp>（</rp><rt>そら</rt><rp>）</rp></ruby>"]
      expect(instance.parse()).to eq markup
    end
  end

  describe '#add_rubi_and_okuri' do
    it 'returns new results' do
      before = {"surface"=>"青い", "reading"=>"あおい", "pos"=>"形容詞"}
      after = {"surface"=>"青い", "reading"=>"あおい", "pos"=>"形容詞", "kanji"=>"青", "okuri"=>"い", "rubi"=>"あお"}
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it 'returns nothing if words are symbol' do
      before = {"surface"=>"、", "reading"=>"、", "pos"=>"特殊"}
      after = {"surface"=>"、", "reading"=>"、", "pos"=>"特殊"}
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it '“大きな”を変換' do
      before = {"surface"=>"大きな", "reading"=>"おおきな", "pos"=>"連体詞"}
      after = {"surface"=>"大きな", "reading"=>"おおきな", "pos"=>"連体詞", "kanji"=>"大", "okuri"=>"きな", "rubi"=>"おお"}
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it '“共通モジュール”を変換' do
      before = {"surface"=>"共通モジュール", "reading"=>"きょうつう", "pos"=>"名詞"}
      after = {"surface"=>"共通モジュール", "reading"=>"きょうつう", "pos"=>"名詞", "kanji"=>"共通", "okuri"=>"モジュール", "rubi"=>"きょうつう"}
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it '“ナカグ・ロー”を変換' do
      before = {"surface"=>"ナカグ・ロー", "reading"=>"", "pos"=>"名詞"}
      after = {"surface"=>"ナカグ・ロー", "reading"=>"", "pos"=>"名詞"}
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end
  end
end

