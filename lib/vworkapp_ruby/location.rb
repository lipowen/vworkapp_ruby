module VWorkApp

  class Location
    include AttributeEquality
    attr_accessor :formatted_address, :lat, :lng
    
    def initialize(formatted_address, lat, lng)
      @formatted_address = formatted_address
      @lat = lat
      @lng = lng
    end
    
    def self.from_address(address, region = :us)
      loc = Location.geocode(address, region).first.geometry.location
      self.new(address, loc.lat, loc.lng)
    end
    
    def to_hash
      { :formatted_address => formatted_address, :lat => lat, :lng => lng }
    end
    
    def self.from_hash(attributes)
      return nil unless attributes
      Location.new(attributes["formatted_address"], attributes["lat"], attributes["lng"])
    end

    def ==(other)
      attributes_eql?(other, [:lat, :lng])
    end
    
    private

    def self.geocode(address, region)
      @gecoder ||= GCoder.connect(:storage => :heap)
      @gecoder[address, { :region => region }]
    end

  end

end