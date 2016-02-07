require 'uri'
require 'cgi'
require 'active_support'
require 'active_support/core_ext'
require 'net/https'

module Rubyrubi
  class API
    BASE_URL = 'http://jlp.yahooapis.jp'
    API_PATH = '/MAService/V1/parse?'
    
    class << self
      def request(app_id, text)
        uri = URI(BASE_URL + API_PATH)
        uri.query = {
          appid: app_id,
          filter: [*1..13].join('|'),
          results: 'ma,uniq',
          sentence: text,
        }.to_param
        #p uri

        http = Net::HTTP.new(uri.host, uri.port)
        responce = http.post(uri.path, uri.query, {'Content-type' => 'application/x-www-form-urlencoded'})

        Hash.from_xml(responce.body)
      end
    end
  end
end



