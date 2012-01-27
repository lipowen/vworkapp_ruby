require 'gcoder'

module VWorkApp

  class Job < Resource
    attr_accessor :id, :customer_name, :template_name, :planned_duration, :steps, :custom_fields, :third_party_id,
                  :worker_id, :planned_start_at

    # Readonly.
    attr_reader :actual_start_at, :actual_duration, :progress_state, :state
    
    #---------------
    # Object Methods
    #---------------

    def initialize(attributes)
      from_hash(attributes)
    end

    def attributes
      [
        :id, :customer_name, :template_name, :planned_duration, {:steps => Array(VW::Step)}, {:custom_fields => Array(VW::CustomField)}, :third_party_id,
        :worker_id, :planned_start_at, :actual_start_at, :actual_duration, :progress_state, :state
      ]
    end

    def to_hash
      { :job => super.to_hash }
    end
    
    def is_new?
      self.id == nil
    end

    def worker
      return nil if @worker_id.nil?
      @worker ||= Worker.show(@worker_id)
    end

    def ==(other)
      attributes_eql?(other, [
        :id, :third_party_id, :customer_name, :template_name, :planned_duration, :planned_start_at, 
        :worker_id, :steps, :custom_fields
      ])
    end

    #---------------
    # REST Methods
    #---------------

    def create
      perform(:post, "/jobs.xml", {}, self.to_hash) do |res|
        Job.from_hash(res["job"])
      end
    end

    def update(use_third_party_id = false)
      perform(:put, "/jobs/#{id}.xml", { :use_third_party_id => use_third_party_id }, self.to_hash)
    end

    def delete(use_third_party_id = false)
      perform(:delete, "/jobs/#{id}.xml", { :use_third_party_id => use_third_party_id })
    end

    def self.show(id, use_third_party_id = false)
      perform(:get, "/jobs/#{id}.xml", :use_third_party_id => use_third_party_id) do |res|
        Job.from_hash(res["job"])
      end
    end

    def self.find(options={})
      third_party_id = options.delete(:third_party_id)
      options[:search] = "@third_party_id=#{third_party_id.to_s}" if (third_party_id)
      options[:api_key] = VWorkApp.api_key
      
      raw = get("/jobs.xml", :query => options)
      raw["jobs"].map { |h| Job.from_hash(h) }
    end
                     
  end

end
