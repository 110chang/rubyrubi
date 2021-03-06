require 'spec_helper'

describe Rubyrubi::Parser::Base do

  let(:response) do
    Hash.from_xml(File.read(File.expand_path('./spec/fixtures/api_responce_1.xml', Dir.pwd)))
  end

  let(:instance) do
    described_class.new(response)
  end

  it 'is exist' do
    expect(instance).not_to be nil
  end

  describe '#parse' do
    it '“青い空、白い雲”を変換' do
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
    it '漢字、送り仮名、ルビのデータを付与する' do
      before = {"surface"=>"青い", "reading"=>"あおい", "pos"=>"形容詞"}
      after = [{"kanji"=>"青", "okuri"=>"い", "rubi"=>"あお"}]
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it '特殊文字にはなにもしない' do
      before = {"surface"=>"、", "reading"=>"、", "pos"=>"特殊"}
      after = {"surface"=>"、", "reading"=>"、", "pos"=>"特殊"}
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it '送り仮名が1文字以上でも正しくデータを付与する' do
      before = {"surface"=>"大きな", "reading"=>"おおきな", "pos"=>"連体詞"}
      after = [{"kanji"=>"大", "okuri"=>"きな", "rubi"=>"おお"}]
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    # it 'カタカナが混じっていても正しくデータを付与する' do
    #   before = {"surface"=>"共通モジュール", "reading"=>"きょうつうもじゅーる", "pos"=>"名詞"}
    #   after = {"surface"=>"共通モジュール", "reading"=>"きょうつうもじゅーる", "pos"=>"名詞", "kanji"=>["共通"], "okuri"=>["モジュール"], "rubi"=>["きょうつう"]}
    #   expect(instance.add_rubi_and_okuri(before)).to eq after
    # end

    it '造語の場合はなにもしない' do
      before = {"surface"=>"ナカグ・ロー", "reading"=>"", "pos"=>"名詞"}
      after = {"surface"=>"ナカグ・ロー", "reading"=>"", "pos"=>"名詞"}
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it '固名商品は変換しないで返す' do
      before = {"surface"=>"進研ゼミ", "reading"=>"", "pos"=>"名詞", "feature"=>"名詞,固名商品,*,進研ゼミ,しんけんぜみ,進研ゼミ"}
      after = {"surface"=>"進研ゼミ", "reading"=>"", "pos"=>"名詞", "feature"=>"名詞,固名商品,*,進研ゼミ,しんけんぜみ,進研ゼミ"}
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it '漢字の間に送り仮名がはさまっている名詞でも正しくルビタグを付与する' do
      before = {"surface"=>"使い方", "reading"=>"つかいかた", "pos"=>"名詞"}
      after = [{"kanji"=>"使", "okuri"=>"い", "rubi"=>"つか"}, {"kanji"=>"方", "rubi"=>"かた"}]
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end

    it '仮に漢字と送り仮名が交互になっても正しくルビタグを付与する' do
      before = {"surface"=>"色は匂えど散", "reading"=>"いろはにおえどちり", "pos"=>"名詞"}
      after = [{"kanji"=>"色", "okuri"=>"は", "rubi"=>"いろ"}, {"kanji"=>"匂", "okuri"=>"えど", "rubi"=>"にお"}, {"kanji"=>"散", "rubi"=>"ちり"}]
      expect(instance.add_rubi_and_okuri(before)).to eq after
    end
  end
end

