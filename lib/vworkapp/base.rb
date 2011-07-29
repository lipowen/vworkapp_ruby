require 'httparty'

module VWorkApp
  
  HEADERS = {
    "User-Agent"    => "Ruby.vWorkApp.API",
    # "Accept"        => "application/xml",
    # "Content-Type"  => "application/xml"
  }

  class Base
    include HTTParty

    base_uri 'api.vworkapp.com/api/2.0'
    # base_uri 'api.vworkapp.com/api/2.0'
    format :xml

    headers HEADERS

    # Examines a bad response and raises an approriate exception
    #
    # @param [HTTParty::Response] response
    def self.bad_response(response)
      if response.class == HTTParty::Response
        raise ResponseError, response
      end
      raise StandardError, "Unkown error"
    end

    def self.api_key=(api_key)
      @@api_key = api_key
    end
    
    def self.api_key
      @@api_key
    end
    
    def api_key
      @@api_key
    end

  end

end
