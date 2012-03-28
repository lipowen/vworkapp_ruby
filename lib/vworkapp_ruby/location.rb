module VWorkApp
  class Location < Base
    hattr_accessor :formatted_address, :lat, :lng
    self.include_root_in_json = false
    
    def self.from_address(address, options = {})
      location_options = { :region => :us }.reverse_merge(options)
      
      loc = Location.geocode(address, location_options).first.geometry.location
      self.new(:formatted_address => address, :lat => loc.lat, :lng => loc.lng)
    end

    def ==(other)
      attributes_eql?(other, :lat, :lng)
    end
    
  private

    def self.geocode(address, options = {})
      gcoder_options = { :storage => :heap }.reverse_merge(options)
      
      @gecoder ||= GCoder.connect(options)
      @gecoder[address, { :region => options[:region] }]
    end

  end
end