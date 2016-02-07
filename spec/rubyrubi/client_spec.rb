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

  it 'is exist' do
    expect(instance).not_to be nil
  end

  describe '#furu' do
    it 'returns xml' do
      result = "<ruby>青<rp>（</rp><rt>あお</rt><rp>）</rp></ruby>い<ruby>空<rp>（</rp><rt>そら</rt><rp>）</rp></ruby>、<ruby>白<rp>（</rp><rt>しろ</rt><rp>）</rp></ruby>い<ruby>雲<rp>（</rp><rt>くも</rt><rp>）</rp></ruby>"
      expect(instance.furu(text)).to eq result
    end
  end
end

