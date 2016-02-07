module Rubyrubi
  module Parser
    KANJI = /[[一-龠]+]/

    class Base
      def initialize(result)
        result = result.with_indifferent_access
        @result = result
        @original = result[:ResultSet][:ma_result][:word_list][:word]
        #p @original
      end

      def parse()
        new_data = []
        @original.each do |word|
          new_data.push(add_rubi_and_okuri(word))
        end
        create_markup(new_data)
      end

      def add_rubi_and_okuri(word)
        #p word
        new_word = word.clone
        word['surface'].scan(KANJI) do |matched|
          okuri = word['surface'].split(matched)[1] || ''
          rubi = okuri != '' ? word['reading'].split(okuri)[0] : word['reading']
          new_word = new_word.merge({
            'kanji' => matched,
            'okuri' => okuri,
            'rubi' => rubi
          })
        end
        new_word
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

