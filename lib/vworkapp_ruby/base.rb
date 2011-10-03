require 'httparty'

module VWorkApp
  
  class << self
    @api_key = "YOU NEED TO SPECIFY YOUR API KEY!!"

    def api_key=(key)
      @api_key = key
    end
    def api_key
      @api_key
    end
  end
      
  class Base

    include HTTParty

    base_uri 'api.vworkapp.com/api/2.0'
    # http_proxy 'localhost', 8888
    # format :xml

    headers({
      "User-Agent" => "Ruby.vWorkApp.API"
    })

    # Examines a bad response and raises an approriate exception
    #
    # @param [HTTParty::Response] response
    def self.bad_response(response)
      if response.class == HTTParty::Response
        raise ResponseError, response
      end
      raise StandardError, "Unkown error"
    end

  end

end
