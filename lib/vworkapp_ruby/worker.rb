module VWorkApp

  class Worker < Base    
    attr_accessor :id, :name, :email, :latest_telemetry, :third_party_id
    
    #---------------
    # Object Methods
    #---------------
    
    def initialize(name, email, id = nil, third_party_id = nil)
      @name = name
      @email = email
      @id = id
      @third_party_id = third_party_id
    end
        
    def self.from_hash(attributes)
      worker = Worker.new(attributes["name"], attributes["email"], attributes["id"], attributes["third_party_id"])
      worker.latest_telemetry = Telemetry.from_hash(attributes["latest_telemetry"]) if attributes["latest_telemetry"]
      worker
    end

    def to_hash
      worker_hash = {
        :worker => {
          :name => self.name,
          :email => self.email
        }
      }
      worker_hash[:worker][:third_party_id] = self.third_party_id if third_party_id
      worker_hash
    end
    
    def ==(other)
      attributes_eql?(other, [:id, :name, :email, :third_party_id])
    end
    
    #---------------
    # REST Methods
    #---------------

    def create
      perform(:post, "/workers", {}, self.to_hash) do |res|
        Worker.from_hash(res["worker"])
      end
    end

    def update(use_third_party_id = false)
      perform(:put, "/workers/#{id}.xml", { :use_third_party_id => use_third_party_id }, self.to_hash)
    end

    def delete(use_third_party_id = false)
      perform(:delete, "/workers/#{id}.xml", { :use_third_party_id => use_third_party_id })
    end

    def self.show(id, use_third_party_id = false)
      perform(:get, "/workers/#{id}.xml", :use_third_party_id => use_third_party_id) do |res|
        Worker.from_hash(res["worker"])
      end
    end    

    def self.find
      self.perform(:get, "/workers.xml") do |res|
        res["workers"].map { |h| Worker.from_hash(h) }
      end
    end
    
  end

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


end