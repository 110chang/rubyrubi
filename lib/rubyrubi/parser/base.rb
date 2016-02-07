module Rubyrubi
  module Parser
    KANJI = /[[一-龠]+]/
    class Base
      def initialize(result)
        @result = result
        @original = result['ResultSet']['ma_result']['word_list']['word']
        p @original
      end

      def parse(build = self.add_rubi_and_okuri)
        new_data = []
        @original.each do |word|
          new_data.push(add_rubi_and_okuri(word))
        end
        new_data
      end

      def add_rubi_and_okuri(word)
        p word
        new_word = word.clone
        word['surface'].scan(KANJI) do |matched|
          okuri = word['surface'].split(matched)[1]
          new_word['kanji'] = matched
          new_word['okuri'] = okuri
          new_word['rubi'] = word['reading'].split(okuri)[0]
        end
        new_word
      end
    end
  end
end
