module Rubyrubi
  class Client
    def initialize(app_id)
      @app_id = app_id
    end

    def furu(text)
      result = API.request(@app_id, text)
      words = []
      result['ResultSet']['ma_result']['word_list']['word'].each do |word|
        word['surface'].scan(/[[一-龠]+]/) do |matched|
          okuri = word['surface'].split(matched)[1]
          rubi = word['reading'].split(okuri)[0]
          words.push(word.merge({
            kanji: matched,
            rubi: rubi,
            okuri: okuri
          }))
        end
      end
      p words
      result
    end
  end
end


