module Rubyrubi
  module Parser
    KANJI = /^[一-龠]+/
    OKURI = /[\p{hiragana}\p{katakana}ー〜]+$/
    KOMEI = /固名商品/

    class Base
      def initialize(result)
        result = result.with_indifferent_access
        @result = result
        @original = result[:ResultSet][:ma_result][:word_list][:word]
        #p @original
      end

      def parse()
        new_data = @original.map do |word|
          add_rubi_and_okuri(word)
        end
        create_markup(new_data)
      end

      def add_rubi_and_okuri(word)
        #p word
        if word['feature'] && word['feature'].scan(KOMEI).size > 0
          return word.clone
        end

        kanji = word['surface'].scan(KANJI)[0]

        if kanji == nil
          return word.clone
        end

        okuri = word['surface'].scan(OKURI)[0]
        rubi = kanji == nil && okuri == nil ? nil
          : word['reading'].gsub(Regexp.new("#{okuri}$"), '')

        new_word = word.clone.merge({
          'kanji' => kanji,
          'okuri' => okuri,
          'rubi' => rubi
        })
        new_word.keep_if { |k, v| v }
      end

      def create_markup(data)
        data.map do |e, i|
          if e['rubi']
            "<ruby>#{e['kanji']}<rp>（</rp><rt>#{e['rubi']}</rt><rp>）</rp></ruby>#{e['okuri'] || ''}"
          else
            "#{e['surface']}"
          end
        end
      end
    end
  end
end

