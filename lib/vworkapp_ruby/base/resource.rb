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

  class Resource
    # include ActiveModel::Serialization
    include HTTParty
    include AttributeMethods

    base_uri 'api.vworkapp.com/api/2.0'
    # http_proxy 'localhost', 8888

    headers({
      "Content-Type" => "text/xml",
      "User-Agent" => "Ruby.vWorkApp.API"
    })
    
    # ------------------
    # Rest Methods
    # ------------------
    
    # def create
    #   perform(:post, "/workers", {}, self.to_hash) do |res|
    #     self.from_hash(res["worker"])
    #   end
    # end
    # 
    # def update(use_third_party_id = false)
    #   perform(:put, "/workers/#{id}.xml", { :use_third_party_id => use_third_party_id }, self.to_hash)
    # end
    # 
    # def delete(use_third_party_id = false)
    #   perform(:delete, "/workers/#{id}.xml", { :use_third_party_id => use_third_party_id })
    # end
    # 
    # def self.show(id, use_third_party_id = false)
    #   perform(:get, "/workers/#{id}.xml", :use_third_party_id => use_third_party_id) do |res|
    #     self.from_hash(res["worker"])
    #   end
    # end
    # 
    # def self.find
    #   self.perform(:get, "/workers.xml") do |res|
    #     res["workers"].map { |h| Worker.from_hash(h) }
    #   end
    # end

    # ------------------
    # ActiveModel Methods
    # ------------------

    def initialize(attributes)
      self.attributes = attributes
    end

    # def persisted?
    #   @persisted
    # end

    # def attributes
    # end
    # 
    # def attributes=
    # end
    # 
    # def self.columns
    #   raise "Yo. Implement me!"
    # end

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
