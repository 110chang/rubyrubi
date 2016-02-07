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
  end
end

