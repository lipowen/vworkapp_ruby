module VWorkApp
  
  class << self
    @api_key = "YOU NEED TO SPECIFY YOUR API KEY!!"
    def api_key=(key)
      @api_key = key
    end
    def api_key
      @api_key
    end

    @api_host = "https://api.vworkapp.com"
    def api_host=(host)
      @api_host = host
    end
    def api_host
      @api_host
    end
  end

  class Resource < Base
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Validations
    include HTTParty

    base_uri "#{VWorkApp.api_host}/api/2.0"
    # http_proxy 'localhost', 8888

    headers({
      "Content-Type" => "text/xml",
      "User-Agent" => "Ruby.vWorkApp.API"
    })

    # ------------------
    # Active Model
    # ------------------
    
    def persisted?
      false
    end
    
    # ------------------
    # Rest Methods
    # ------------------
    
    def create
      validate_and_raise
      perform(:post, "/#{resource_name.pluralize}", {}, self.to_xml) do |res|
        self.class.new(res[resource_name])
      end
    end

    def update(options = {})
      validate_and_raise
      perform(:put, "/#{resource_name.pluralize}/#{id}.xml", options, self.to_xml)
    end
    
    def delete(options = {})
      perform(:delete, "/#{resource_name.pluralize}/#{id}.xml", options)
    end
    
    def self.show(id, options = {})
      perform(:get, "/#{resource_name.pluralize}/#{id}.xml", options) do |res|
        self.new(res[resource_name])
      end
    end
    
    def self.find(options = {})
      self.perform(:get, "/#{resource_name.pluralize}.xml", options) do |res|
        res[resource_name.pluralize].map { |h| self.new(h) }
      end
    end
        
    # ------------------
    # Misc Methods
    # ------------------
        
    def self.resource_name
      @resource_name ||= ActiveSupport::Inflector.demodulize(self).underscore
    end
    def resource_name
      self.class.resource_name
    end

    def self.perform(action, url, query = {}, body = nil)
      options = {}
      options[:query] = { :api_key => VWorkApp.api_key }.merge(query)

      options[:body] = body
      
      raw = self.send(action, url, options)

      case raw.response
      when Net::HTTPOK, Net::HTTPCreated
        yield(raw) if block_given?
      when Net::HTTPNotFound
        nil
      else
        bad_response(raw)
      end
    end
    def perform(action, url, query = {}, body = nil, &block)
      self.class.perform(action, url, query, body, &block)
    end

    def self.bad_response(raw)
      raise ResponseError.new(raw)
    end
    
  end

end
