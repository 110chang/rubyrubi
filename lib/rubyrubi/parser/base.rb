module Rubyrubi
  module Parser
    KANJI = /[一-龠]+/
    OKURI = /[\p{hiragana}\p{katakana}ー＝〜・]+/
    KOMEI = /固名商品/

    def self.ruby_tag(text, ruby)
      "<ruby>#{text}<rp>（</rp><rt>#{ruby}</rt><rp>）</rp></ruby>"
    end

    class Base
      def initialize(result)
        result = result.with_indifferent_access
        @result = result
        @original = result[:ResultSet][:ma_result][:word_list][:word]
      end

      def parse()
        new_data = @original.map do |word|
          add_rubi_and_okuri(word)
        end
        create_markup(new_data)
      end

      def add_rubi_and_okuri(word)
        if word['feature'] && word['feature'].scan(KOMEI).size > 0
          return word.clone
        end

        kanji = word['surface'].scan(KANJI)
        okuri = word['surface'].scan(OKURI)
        yomi = '' + word['reading']

        return word.clone if !kanji || kanji.size == 0

        kanji.map.with_index do |k, i|
          ret = { 'kanji' => k }
          oku = okuri[i]
          rubi = ''
          if oku
            ret.merge!({ 'okuri' => oku })
            rubi = yomi.slice(0, yomi.index(oku))
            yomi = yomi.slice(yomi.index(oku) + oku.length, yomi.length)
          else
            rubi = yomi
          end
          ret.merge!({ 'rubi' => rubi })
        end
      end

      def create_markup(data)
        data.map.with_index do |e, i|
          if e.class == Array
            e.map do |r|
              Parser.ruby_tag(r['kanji'], r['rubi']) << "#{r['okuri'] ? r['okuri'] : ''}"
            end.join('')
          elsif e['surface']
            "#{e['surface']}"
          end
        end
      end
    end
  end
end

