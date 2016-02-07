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
      before = [{"surface"=>"青い", "reading"=>"あおい", "pos"=>"形容詞"}, {"surface"=>"空", "reading"=>"そら", "pos"=>"名詞"}, {"surface"=>"、", "reading"=>"、", "pos"=>"特殊"}, {"surface"=>"白い", "reading"=>"しろい", "pos"=>"形容詞"}, {"surface"=>"雲", "reading"=>"くも", "pos"=>"名詞"}]
      after = [{"surface"=>"青い", "reading"=>"あおい", "pos"=>"形容詞", "kanji"=>"青", "okuri"=>"い", "rubi"=>"あお"}, {"surface"=>"空", "reading"=>"そら", "pos"=>"名詞", "kanji"=>"空", "okuri"=>nil, "rubi"=>"そら"}, {"surface"=>"、", "reading"=>"、", "pos"=>"特殊"}, {"surface"=>"白い", "reading"=>"しろい", "pos"=>"形容詞", "kanji"=>"白", "okuri"=>"い", "rubi"=>"しろ"}, {"surface"=>"雲", "reading"=>"くも", "pos"=>"名詞", "kanji"=>"雲", "okuri"=>nil, "rubi"=>"くも"}]
      expect(instance.parse(before)).to eq after
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

