
module VWorkApp

  class Location
    attr_accessor :formatted_address, :lat, :long
    def initialize(formatted_address, lat, long)
      self.formatted_address = formatted_address
      self.lat = lat
      self.long = long
    end
    
    def to_hash
      { :formatted_address => formatted_address, :lat => lat, :lng => long }
    end
    
  end

  class Step
    attr_accessor :name, :location
    def initialize(name, location = nil)
      self.name = name
      self.location = location
    end

    def to_hash
      h = { :name => name }
      h.merge! { :location=> location.to_hash } if location  
      h
    end
  end

  class CustomField
    attr_accessor :name, :value
    def initialize(name, value)
      self.name = name
      self.value = value
    end

    def to_hash
      { :name => name.to_s, :value => value.to_s }
    end
  end

  class Job < Base
    
    attr_accessor :id, :customer_name, :template_name, :planned_duration, :steps, :custom_fields, :assigned_to, :planned_start_at

    ##
    # Creates a new jobs in vWorkApp.
    # 
    # Steps and Custom_Fields takes an array of these.
    # 
    def initialize(customer_name, template_name, planned_duration, steps, custom_fields = nil, assigned_to = nil, planned_start_at = nil)
      self.customer_name = customer_name
      self.template_name = template_name, 
      self.planned_duration = planned_duration, 
      self.steps = steps, 
      self.custom_fields = custom_fields, 
      self.assigned_to = assigned_to,
      self.planned_start_at = planned_start_at
    end
    
    def is_new?
      self.id == nil
    end
    
    def to_hash
      {
        :job => {
          :customer_name => self.customer_name,
          :template_name  => self.template_name,
          # :planned_duration => self.planned_duration,
          :steps =>  steps.map { |s| s.to_hash },
          :custom_fields  => steps.map { |s| s.to_hash }
        }
      }
    end
    
    def create
      res = self.class.post("/jobs", :body => self.to_hash, :query => { :api_key => self.class.api_key })
      res.success? ? res : self.class.bad_response(res)
    end

    def update(id, attributes)
      res = post("/jobs", :body => { :job => self.to_hash }, :query => { :api_key => api_key })
      res.success? ? res : bad_response(res)
    end

    def self.all
      find
    end

    # Valid options are: 
    #   - :state — Filter by state. Possible values: unallocated, allocated, assigned, not_started, started, completed.
    #   - :start_at — Filter by planned_start_at/last_action_time (must also give end_at).
    #   - :end_at — Filter by planned_start_at/last_action_time (must also give start_at).
    #   - :customer_name — Filter by customer name.
    #   - :worker_id — Filter by assigned worker.
    #   - :worker_third_party_id — Filter by assigned worker third party id.
    #   - :per_page — The number of records to return per page.
    #   - :page — The page of records to return.
    def self.find(options={})
      options.merge!({:api_key => api_key})
      get("/jobs.xml", :query => options)["jobs"]
    end

    def self.show(id)
      get("/jobs/#{id}.xml", :query => { :api_key => api_key })
    end
    
    def self.delete(id)
      
    end
    
  end

end
