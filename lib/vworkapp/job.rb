require 'httparty'

module VWorkApp

  class Job < Base

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
      get("/jobs/#{id}.xml", :query => {:api_key => api_key})
    end
      
    def self.create(attributes = {})
      res = post("/jobs", :body => {:job => attributes}, :query => {:api_key => api_key})
      res.success? ? res : bad_response(res)
    end
    
    def self.update(id, attributes)
      
    end

    def self.delete(id)
      
    end
    
  end

end
