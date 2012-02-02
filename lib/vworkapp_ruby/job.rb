require 'gcoder'

module VWorkApp
  class Job < Resource
    hattr_accessor :id, :customer_name, :template_name, :planned_duration, {:steps => Array(VWorkApp::Step)}, :published_at,
                   {:custom_fields => Array(VWorkApp::CustomField)}, :third_party_id, :worker_id, :planned_start_at, :customer_id

    hattr_reader :actual_start_at, :actual_duration, :progress_state, :state

    validates_presence_of :template_name, :planned_duration, :steps
    validate :customer_validation
    
    def customer_validation
      return true if @customer_id || @customer_name
      error_str = "- Either customer_name OR customer_id must be present"
      self.errors.add :customer_name, error_str
      self.errors.add :customer_id, error_str
    end
    
    def customer
      return nil if @customer_id.nil?
      @customer ||= Customer.show(@customer_id)
    end

    def worker
      return nil if @worker_id.nil?
      @worker ||= Worker.show(@worker_id)
    end

    # XXX Published at also needs to be set. 
    def planned_start_at=(datetime)
      self.published_at = datetime
      @planned_start_at = datetime
    end

    # XXX Work around for API bug that doesn't accept a nil contact detail. 
    def to_xml(options = {})
      except = options[:except] || []
      except << "custom_fields" unless custom_fields
      except << "customer_id" unless customer_id && customer_name.nil?

      super(:except => except)
    end
    
    def ==(other)
      attributes_eql?(other, :id, :third_party_id, :customer_name, :template_name, :planned_duration, :planned_start_at, 
        :worker_id, :steps, :custom_fields)
    end

  end
end
