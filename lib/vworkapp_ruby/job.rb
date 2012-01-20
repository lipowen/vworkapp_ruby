require 'gcoder'

module VWorkApp

  class Job < Base
    attr_accessor :id, :customer_name, :template_name, :planned_duration, :steps, :custom_fields, :third_party_id
    attr_accessor :assigned_to_id, :planned_start_at, :progress_state

    #---------------
    # Object Methods
    #---------------

    def initialize(customer_name, template_name, planned_duration, steps, custom_fields = nil, id = nil, third_party_id = nil, assigned_to_id = nil, planned_start_at = nil)
      @id = id
      @customer_name = customer_name
      @template_name = template_name
      @planned_duration = planned_duration 
      @steps = steps
      @custom_fields = custom_fields 
      @third_party_id = third_party_id
      @assigned_to_id = assigned_to_id
      @planned_start_at = planned_start_at
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
    
    def is_new?
      self.id == nil
    end

    def assigned_to
      return nil if @assigned_to_id.nil?
      @assigned_to ||= Worker.show(self.assigned_to_id)
    end

    def ==(other)
      attributes_eql?(other, [
        :id, :third_party_id, :customer_name, :template_name, :planned_duration, :planned_start_at, 
        :assigned_to_id, :steps, :custom_fields
      ])
    end

    #---------------
    # REST Methods
    #---------------

    def create
      perform(:post, "/jobs.xml", {}, self.to_hash) do |res|
        Job.from_hash(res["job"])
      end

      # res = self.class.post("/jobs", :body => self.to_hash, :query => { :api_key => VWorkApp.api_key })
      # if res.success?
      #   self.id = res["job"]["id"]
      #   self 
      # else
      #   self.class.bad_response(res)
      # end
    end

    def update(id, attributes)
      res = self.class.post("/jobs", :body => { :job => self.to_hash }, :query => { :api_key => VWorkApp.api_key })
      res.success? ? res : bad_response(res)
    end

    def delete(use_third_party_id = false)
      perform(:delete, "/jobs/#{id}.xml", { :use_third_party_id => use_third_party_id })
    end

    def self.show(id, use_third_party_id = false)
      perform(:get, "/jobs/#{id}.xml", :use_third_party_id => use_third_party_id) do |res|
        Job.from_hash(res["job"])
      end
      # raw = get("/jobs/#{id}.xml", :query => { :api_key => VWorkApp.api_key, :use_third_party_id => use_third_party_id })
      # case res
      # when Net::HTTPOK
      #   Job.from_hash(raw["job"])
      # when Net::HTTPNotFound
      #    nil
      # else
      #   bad_response(res)
      # end
    end

    def self.find(options={})
      third_party_id = options.delete(:third_party_id)
      options[:search] = "@third_party_id=#{third_party_id.to_s}" if (third_party_id)
      options[:api_key] = VWorkApp.api_key
      
      raw = get("/jobs.xml", :query => options)
      raw["jobs"].map { |h| Job.from_hash(h) }
    end
            
  end

  class Step
    include AttributeEquality
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

    def ==(other)
      attributes_eql?(other, [:name, :location])
    end
    
  end

  class CustomField
    include AttributeEquality
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
    
    def ==(other)
      attributes_eql?(other, [:name, :value])
    end

  end

end
