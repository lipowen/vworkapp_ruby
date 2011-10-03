module VWorkApp

  class Telemetry
    attr_accessor :lat, :lng, :recorded_at, :heading, :speed
    def initialize (lat, lng, recorded_at, heading, speed)
      @lat = lat
      @lng = lng
      @recorded_at = recorded_at
      @heading = heading
      @speed = speed
    end
    
    def self.from_hash(attributes)
      @lat = attributes["lat"]
      @lng = attributes["lng"]
      @recorded_at = attributes["recorded_at"]
      @heading = attributes["heading"]
      @speed = attributes["speed"]
    end
    
  end

  class Worker < Base
    
    attr_accessor :id, :name, :email, :latest_telemetry, :third_party_id
    
    def initialize(name, email, id = nil, third_party_id = nil)
      @name = name
      @email = email
      @id = id
      @third_party_id = third_party_id
    end
    
    def self.all
      find
    end

    def self.find
      raw = get("/workers.xml", :query => { :api_key => VWorkApp.api_key })["workers"]
      raw.map { |h| Worker.from_hash(h) }
    end
    
    def self.from_hash(attributes)
      w = Worker.new(attributes["name"], attributes["email"], attributes["id"], attributes["third_party_id"])
      w.latest_telemetry = Telemetry.from_hash(attributes["latest_telemetry"]) if attributes["latest_telemetry"]
      w
    end
    
  end

end