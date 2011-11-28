require 'gcoder'

module VWorkApp

  class Location
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
    
  private

    def self.geocode(address, region)
      @gecoder ||= GCoder.connect(:storage => :heap)
      @gecoder[address, { :region => region }]
    end

  end

  class Step
    attr_accessor :name, :location
    def initialize(name, location = nil)
      @name = name
      @location = location
    end

    def to_hash
      h = { :name => name }
      h.merge!({ :location => location.to_hash }) if location  
      h
    end
    
    def self.from_hash(attributes)
      Step.new(attributes["name"], Location.from_hash(attributes["location"]))
    end
    
  end

  class CustomField
    attr_accessor :name, :value
    def initialize(name, value)
      @name = name
      @value = value
    end

    def to_hash
      { :name => name.to_s, :value => value.to_s }
    end
    
    def self.from_hash(attributes)
      CustomField.new(attributes["name"], attributes["value"])
    end
    
  end

  class Job < Base
    
    attr_accessor :id, :customer_name, :template_name, :planned_duration, :steps, :custom_fields, :third_party_id
    attr_accessor :assigned_to_id, :planned_start_at, :progress_state

    ##
    # Creates a new jobs in vWorkApp.
    # 
    # Steps and Custom_Fields takes an array of these.
    # 
    def initialize(customer_name, template_name, planned_duration, steps, custom_fields = nil, id = nil, third_party_id = nil, assigned_to = nil, planned_start_at = nil)
      @id = id
      @customer_name = customer_name
      @template_name = template_name 
      @planned_duration = planned_duration 
      @steps = steps
      @custom_fields = custom_fields 
      @third_party_id = third_party_id
      @assigned_to_id = assigned_to.id if assigned_to
      @planned_start_at = planned_start_at
    end
        
    def is_new?
      self.id == nil
    end
    
    def to_hash
      job_hash = {
        :job => {
          :customer_name => self.customer_name,
          :template_name  => self.template_name,
          :planned_duration => self.planned_duration,
          :steps =>  self.steps.map { |s| s.to_hash },
        }
      }
      job_hash[:job][:third_party_id] = self.third_party_id if third_party_id
      job_hash[:job][:custom_fields] = self.custom_fields.map { |s| s.to_hash } if custom_fields
      job_hash
    end

    def self.from_hash(attributes)
      job = Job.new(attributes["customer_name"], attributes["template_name"], attributes["planned_duration"], 
                  attributes["steps"].map { |h| Step.from_hash(h) }, nil, attributes["id"], attributes["third_party_id"])      
      job.custom_fields = attributes["custom_fields"].map { |h| CustomField.from_hash(h) } if attributes["custom_fields"]
      
      job.assigned_to_id = attributes["worker_id"]
      job.planned_start_at = attributes["planned_start_at"]
      job.progress_state = attributes["progress_state"]
      
      job
    end
    
    def create
      res = self.class.post("/jobs", :body => self.to_hash, :query => { :api_key => VWorkApp.api_key })
      if res.success?
        self.id = res["job"]["id"]
        self 
      else
        self.class.bad_response(res)
      end
    end

    def update(id, attributes)
      res = self.class.post("/jobs", :body => { :job => self.to_hash }, :query => { :api_key => VWorkApp.api_key })
      res.success? ? res : bad_response(res)
    end

    def self.all
      find
    end

    ##
    # Returns jobs that match the given query options. Valid options are:
    #   - :state — Filter by state. Possible values: unallocated, allocated, assigned, not_started, started, completed.
    #   - :start_at — Filter by planned_start_at/last_action_time (must also give end_at).
    #   - :end_at — Filter by planned_start_at/last_action_time (must also give start_at).
    #   - :customer_name — Filter by customer name.
    #   - :worker_id — Filter by assigned worker.
    #   - :worker_third_party_id — Filter by assigned worker third party id.
    #   - :per_page — The number of records to return per page.
    #   - :page — The page of records to return.
    #   - :third_party_id — The third_party_id associated with the job.
    def self.find(options={})
      third_party_id = options.delete(:third_party_id)
      options[:search] = "@third_party_id=#{third_party_id.to_s}" if (third_party_id)
      options[:api_key] = VWorkApp.api_key
      
      raw = get("/jobs.xml", :query => options)
      raw["jobs"].map { |h| Job.from_hash(h) }
    end

    def self.show(id, use_third_party_id = false)
      raw = get("/jobs/#{id}.xml", :query => { :api_key => VWorkApp.api_key, :use_third_party_id => use_third_party_id })
      case res
      when Net::HTTPOK
        Job.from_hash(raw["job"])
      when Net::HTTPNotFound
         nil
      else
        bad_response(res)
      end
    end
        
    def self.delete(id)      
    end
    
    def assigned_to
      return nil if @assigned_to_id.nil?
      @assigned_to ||= Worker.show(self.assigned_to_id)
    end
        
  end

end
