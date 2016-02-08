require 'yaml'
require 'spec_helper'

describe Rubyrubi::Client do

  let(:app_id) do
    YAML.load_file(File.expand_path('./spec/spec_config.yml', Dir.pwd))['api_key']
  end

  let(:instance) do
    described_class.new(app_id)
  end

  let(:text) do
    '青い空、白い雲'
  end

  it 'is exist' do
    expect(instance).not_to be nil
  end

  describe '#furu' do
    it 'rubyタグを返す' do
      result = "<ruby>青<rp>（</rp><rt>あお</rt><rp>）</rp></ruby>い<ruby>空<rp>（</rp><rt>そら</rt><rp>）</rp></ruby>、<ruby>白<rp>（</rp><rt>しろ</rt><rp>）</rp></ruby>い<ruby>雲<rp>（</rp><rt>くも</rt><rp>）</rp></ruby>"
      expect(instance.furu(text)).to eq result
    end

    it 'rubyタグを返す' do
      result = "<ruby>大<rp>（</rp><rt>おお</rt><rp>）</rp></ruby>きな<ruby>空<rp>（</rp><rt>そら</rt><rp>）</rp></ruby>"
      expect(instance.furu('大きな空')).to eq result
    end
  end
end

