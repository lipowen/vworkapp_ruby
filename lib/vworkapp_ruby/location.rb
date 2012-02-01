module VWorkApp
  class Location < Base
    hattr_accessor :formatted_address, :lat, :lng
    self.include_root_in_json = false
    
    def self.from_address(address, region = :us)
      loc = Location.geocode(address, region).first.geometry.location
      self.new(:formmated_address => address, :lat => loc.lat, :lng => loc.lng)
    end

    def ==(other)
      attributes_eql?(other, :lat, :lng)
    end
    
  private

    def self.geocode(address, region)
      @gecoder ||= GCoder.connect(:storage => :heap)
      @gecoder[address, { :region => region }]
    end

  end
end