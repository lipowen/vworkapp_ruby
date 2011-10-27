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
      Telemetry.new(attributes["lat"], attributes["lng"], attributes["recorded_at"], attributes["heading"], attributes["speed"])
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
      raw = get("/workers.xml", :query => { :api_key => VWorkApp.api_key })
      raw["workers"].map { |h| Worker.from_hash(h) }
    end
    
    def self.from_hash(attributes)
      worker = Worker.new(attributes["name"], attributes["email"], attributes["id"], attributes["third_party_id"])
      worker.latest_telemetry = Telemetry.from_hash(attributes["latest_telemetry"]) if attributes["latest_telemetry"]
      worker
    end

    def self.show(id)
      raw = get("/workers/#{id}.xml", :query => { :api_key => VWorkApp.api_key })
      Worker.from_hash(raw["worker"])
    end
    
  end

end