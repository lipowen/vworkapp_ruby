require 'httparty'
require 'active_support/core_ext/hash'

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
      
  module AttributeEquality
    def attributes_eql?(other, attributes)
      attributes.each do |attribute|
        return false unless self.send(attribute.to_sym) == other.send(attribute.to_sym)
      end
      true
    end
  end

  class Base
    include HTTParty
    include AttributeEquality

    base_uri 'api.vworkapp.com/api/2.0'
    # http_proxy 'localhost', 8888

    headers({
      "Content-Type" => "text/xml",
      "User-Agent" => "Ruby.vWorkApp.API"
    })

    def self.perform(action, url, query = {}, body = nil)
      options = {}
      options[:query] = { :api_key => VWorkApp.api_key }.merge(query)

      if body 
        root = body.keys.first
        body_str = body[root].to_xml(:root => root)
        options[:body] = body_str 
      end
      
      raw = self.send(action, url, options)
            
      case raw.response
      when Net::HTTPOK, Net::HTTPCreated
        yield(raw) if block_given?
      when Net::HTTPNotFound
         nil
      else
        bad_response(raw.response)
      end
    end
    
    def perform(action, url, query = {}, body = nil, &block)
      self.class.perform(action, url, query, body, &block)
    end

    def self.bad_response(response)
      raise "#{response.code} - #{response.msg}: #{response.body}"
    end
    
  end

end
