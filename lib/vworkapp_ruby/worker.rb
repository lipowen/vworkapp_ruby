module VWorkApp

  class Worker < Resource    

    attr_accessor :id, :name, :email, :latest_telemetry, :third_party_id
    attr_reader :latest_telemetry

    #---------------
    # Object Methods
    #---------------
    
    def initialize(name, email, id = nil, third_party_id = nil)
      @name = name
      @email = email
      @id = id
      @third_party_id = third_party_id
    end

    def attributes
      [:id, :name, :email, :third_party_id, {:latest_telemetry => VW::Telemetry}]
    end

    def ==(other)
      attributes_eql?(other, [:id, :name, :email, :third_party_id])
    end

    def to_hash
      { :worker => super.to_hash }
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


end