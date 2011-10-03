module VWorkApp

  class Worker < Base
    def self.all
      find
    end

    def self.find
      get("/workers.xml", :query => {:api_key => api_key})["workers"]
    end
    
  end

end