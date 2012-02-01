require "vworkapp_ruby"

describe VW::Job do

  before(:all) do
    VW::Job.base_uri 'https://api.staging.vworkapp.com/api/2.0'
    VW::Worker.base_uri 'https://api.staging.vworkapp.com/api/2.0'
    VW::Customer.base_uri 'https://api.staging.vworkapp.com/api/2.0'
    VW.api_key = "AtuogECLCV2R7uT-fkPg"
  end

  context "Without a known job" do

    describe "#Create" do
      
      it "Assigns the new job an id" do
        @job = VW::Job.new(:customer_name => "Joe", :template_name => "Std Delivery", :planned_duration => 60, 
          :steps => [
            {:name  => "Start", :location => {:formatted_address => "880 Harrison St", :lat => 37.779536, :lng => -122.401503}},
            {:name  => "End",   :location => {:formatted_address => "Other Street", :lat => 38.779536, :lng => -123.401503}},
          ],
          :custom_fields => [
            {:name => "Note", :value => "Hi There!"}
          ])
          
        @job = @job.create
        @job.id.should_not be_nil
      end
    
      it "Creates an unassigned job" do
        @job = VW::Job.new(:customer_name => "Joe", :template_name => "Std Delivery", :planned_duration => 60, 
          :steps => [
            {:name  => "Start", :location => {:formatted_address => "880 Harrison St", :lat => 37.779536, :lng => -122.401503}},
            {:name  => "End",   :location => {:formatted_address => "Other Street", :lat => 38.779536, :lng => -123.401503}},
          ])
          
        @job = @job.create
        r_job = VW::Job.show(@job.id)
        r_job.customer_name.should == @job.customer_name
        r_job.template_name.should == @job.template_name
        r_job.planned_duration.should == @job.planned_duration
        r_job.state.should == "unallocated"
        r_job.progress_state.should == "not_started"
        r_job.steps.should == @job.steps
      end

      it "Creates an unassigned job with Custom Fields" do
        @job = VW::Job.new(:customer_name => "Joe", :template_name => "Std Delivery", :planned_duration => 60, 
          :steps => [
            {:name  => "Start", :location => {:formatted_address => "880 Harrison St", :lat => 37.779536, :lng => -122.401503}},
            {:name  => "End",   :location => {:formatted_address => "Other Street", :lat => 38.779536, :lng => -123.401503}},
          ],
          :custom_fields => [
            {:name => "Note1", :value => "Value1"},
            {:name => "Note2", :value => "Value2"}
          ])

        @job = @job.create
        r_job = VW::Job.show(@job.id)
        r_job.custom_fields.should == @job.custom_fields
      end

      it "Creates and assigns a job" do
        @worker = VW::Worker.new(:name => "Joe", :email => "joe@example.com")
        @worker = @worker.create

        planned_start_at = Time.parse("2012-12-25 16:30-8")
        
        @job = VW::Job.new(:customer_name => "Joe", :template_name => "Std Delivery", :planned_duration => 60,
          :worker_id => @worker.id, :planned_start_at => planned_start_at,
          :steps => [
            {:name  => "Start", :location => {:formatted_address => "880 Harrison St", :lat => 37.779536, :lng => -122.401503}},
            {:name  => "End",   :location => {:formatted_address => "Other Street", :lat => 38.779536, :lng => -123.401503}},
          ])
        @job = @job.create

        r_job = VW::Job.show(@job.id)
        r_job.worker_id.should == @worker.id
        r_job.state.should == "assigned"
        r_job.planned_start_at.should == planned_start_at
      end

      it "Creates a job with completed steps" do
        pending("Broken until https://github.com/visfleet/vworkapp_ruby/issues/1 is resolved")
        @worker = VW::Worker.new(:name => "Joe", :email => "joe@example.com")
        @worker = @worker.create
        
        planned_start_at = Time.parse("2012-12-25 16:30-8")
        actual_start_at = Time.at(Time.now.to_i)
        
        @job = VW::Job.new(:customer_name => "Joe", :template_name => "Std Delivery", :planned_duration => 60,
          :worker_id => @worker.id, :planned_start_at => planned_start_at,
          :steps => [
            {:name  => "Start", :location => {:formatted_address => "880 Harrison St", :lat => 37.779536, :lng => -122.401503}, :completed_at => actual_start_at},
            {:name  => "End",   :location => {:formatted_address => "Other Street", :lat => 38.779536, :lng => -123.401503}},
          ])
        @job = @job.create
      
        r_job = VW::Job.show(@job.id)
        r_job.worker_id.should == @worker.id
        r_job.progress_state.should == "started"
        r_job.actual_start_at == actual_start_at
        r_job.planned_start_at.should == planned_start_at
      end
      
    end

    after(:each) do
      @job.delete if @job
      @worker.delete if @worker
    end

  end

  context "With a known job" do
    before(:each) do
      @job = VW::Job.new(:customer_name => "Joe", :template_name => "Std Delivery", :planned_duration => 60, :third_party_id => "my_id",
        :steps => [
          {:name  => "Start", :location => {:formatted_address => "880 Harrison St", :lat => 37.779536, :lng => -122.401503}},
          {:name  => "End",   :location => {:formatted_address => "Other Street", :lat => 38.779536, :lng => -123.401503}},
        ],
        :custom_fields => [
          {:name => "Note", :value => "Hi There!"}
        ])
      @job = @job.create
    end
  
    after(:each) do
      @job.delete if @job
      @worker.delete if @worker
    end
  
    describe "#Show" do
      it "Returns the job" do
        r_job = VW::Job.show(@job.id)
        r_job.customer_name.should == "Joe"
        r_job.template_name.should == "Std Delivery"
        r_job.state == "unallocated"
        r_job.progress_state == "not_started"
      end
  
      it "Returns nil if not found" do
        r_job = VW::Job.show(-1)
        r_job.should be_nil
      end
    end
  
    describe "#Update" do

      it "Updates the standard attributes" do
        @job.customer_name = "Joe2"
        @job.template_name == "Not Standard"
        @job.planned_duration == 64
        @job.update

        r_job = VW::Job.show(@job.id)
        r_job.customer_name.should == @job.customer_name
        r_job.template_name.should == @job.template_name
        r_job.planned_duration.should == @job.planned_duration
      end

      it "Assigns a job" do
        @worker = VW::Worker.new(:name => "Joe", :email => "joe@example.com")
        @worker = @worker.create

        start_at = Time.at(Time.now.to_i)

        @job.planned_start_at = start_at
        @job.worker_id = @worker.id
        @job.update

        r_job = VW::Job.show(@job.id)
        r_job.worker_id.should == @worker.id
        r_job.planned_start_at.should == start_at
        r_job.published_at.should == start_at
        r_job.state.should == "assigned"
      end
      
      it "Starts a job" do
        pending("Broken until https://github.com/visfleet/vworkapp_ruby/issues/1 is resolved")
      end

      it "Completes a job" do
        pending("Broken until https://github.com/visfleet/vworkapp_ruby/issues/1 is resolved")
      end

    end
  
    describe "#Delete" do
      it "Deletes the job" do
        @job.delete
        r_job = VW::Job.show(@job.id)
        r_job.should be_nil
      end
    end
  
    describe "#Find" do
      it "Finds all jobs" do
        results = VW::Job.find
        results.should be_instance_of(Array)
        results.should include(@job)
      end
    end

    describe "#Assocation Connivence Methods" do

      it "Loads the job's customer" do
        r_customer = VW::Job.show(@job.id).customer        
        r_customer.should be_instance_of VW::Customer
        r_customer.name.should == "Joe"
      end

      it "Loads the job's worker" do
        @worker = VW::Worker.new(:name => "Joe", :email => "joe@example.com")
        @worker = @worker.create
        @job.planned_start_at = Time.now
        @job.worker_id = @worker.id
        @job.update

        r_job = VW::Job.show(@job.id)
        r_job.worker.should == @worker
      end

    end
    
  end


end
