module Rubyrubi
  class Client
    def initialize(app_id)
      @app_id = app_id
    end

    def furu(text)
      result = API.request(@app_id, text)
      parser = Parser::Base.new(result)
      parser.parse().join('')
    end

    def tag(text, ruby)
      Parser.ruby_tag(text, ruby)
    end
  end
end

