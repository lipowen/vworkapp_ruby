require "vworkapp_ruby"

describe VW::Job do

  before(:all) do
    VW::Job.base_uri 'api.staging.vworkapp.com/api/2.0'
    VW.api_key = "AtuogECLCV2R7uT-fkPg"
  end

  context "Without a known job" do

    describe "#Equals" do

      it "Is equal to another job if it has the same attributes, steps, and custom_fields" do
        job_1 = VW::Job.new("Joe", "Std Delivery", 60, 
          [
            VW::Step.new("Start", VWorkApp::Location.new("880 Harrison St", 37.779536, -122.401503)),
            VW::Step.new("End",   VWorkApp::Location.new("Other Street", 38.779536, -123.401503))
          ],
          [
            VW::CustomField.new("Note", "Hi There!")
          ],
          100, 202, 101, Date.new(2001,2,3)
        )
        job_2 = VW::Job.new("Joe", "Std Delivery", 60, 
          [
            VW::Step.new("Start", VWorkApp::Location.new("880 Harrison St!", 37.779536, -122.401503)),
            VW::Step.new("End",   VWorkApp::Location.new("Other Street", 38.779536, -123.401503))
          ],
          [
            VW::CustomField.new("Note", "Hi There!")
          ],
          100, 202, 101, Date.new(2001,2,3)
        )
        job_1.should == job_2
      end

      it "Isn't equal to another job if doesn't share the key attributes" do
        job_1 = VW::Job.new("Joe", "Std Delivery", 60, nil, nil, 100, 202, 101, Date.new(2001,2,3))
        job_2 = VW::Job.new("Joe", "Std Delivery", 60, nil, nil, 100, 202, 101, Date.new(2001,4,3))
        job_1.should_not == job_2
      end

      it "Isn't equal to another job if doesn't share the same steps" do
        job_1 = VW::Job.new("Joe", "Std Delivery", 60, [
            VW::Step.new("Start", VWorkApp::Location.new("880 Harrison St", 37.779536, -122.401503)),
            VW::Step.new("End",   VWorkApp::Location.new("Other Street", 38.779536, -122.401503))
        ])
        job_2 = VW::Job.new("Joe", "Std Delivery", 60, [
            VW::Step.new("Start", VWorkApp::Location.new("880 Harrison St", 37.779536, -122.401503)),
            VW::Step.new("End",   VWorkApp::Location.new("DIFFERENT", 38.779536, 100))
        ])
        job_1.should_not == job_2
      end

      it "Isn't equal to another job if doesn't share the same custom fields" do
        job_1 = VW::Job.new("Joe", "Std Delivery", 60, nil, [
            VW::CustomField.new("Note1", "Value1"),
            VW::CustomField.new("Note2", "Value2"),
        ])
        job_2 = VW::Job.new("Joe", "Std Delivery", 60, nil, [
            VW::CustomField.new("Note1", "Value1"),
            VW::CustomField.new("Note2", "DIFFERENT"),
        ])
        job_1.should_not == job_2
      end

    end

    describe "#Create" do
      
      it "Assigns the new job an id" do
        @job = VW::Job.new("Joe", "Std Delivery", 60, 
          [
            VW::Step.new("Start", VWorkApp::Location.new("880 Harrison St", 37.779536, -122.401503)),
            VW::Step.new("End",   VWorkApp::Location.new("Other Street", 38.779536, -123.401503))
          ],
          [
            VW::CustomField.new("Note", "Hi There!")
          ],
          100, 202, 101, Date.new(2001,2,3)
        )
        
        @job = @job.create
        @job.id.should_not be_nil
      end
    
      it "Creates an unassigned job" do
        @job = VW::Job.new("Joe", "Std Delivery", 60,
        [
          VW::Step.new("Start", VWorkApp::Location.new("880 Harrison St", 37.779536, -122.401503)),
          VW::Step.new("End",   VWorkApp::Location.new("Other Street", 38.779536, -123.401503))
        ])
        @job = @job.create
        r_job = VW::Job.show(@job.id)
        r_job.customer_name.should == @job.customer_name
        r_job.template_name.should == @job.template_name
        r_job.planned_duration.should == @job.planned_duration
        r_job.steps.should == @job.steps
      end

      it "Creates an unassigned job with Custom Fields" do
        @job = VW::Job.new("Joe", "Std Delivery", 60,
          [
            VW::Step.new("Start", VWorkApp::Location.new("880 Harrison St", 37.779536, -122.401503)),
            VW::Step.new("End",   VWorkApp::Location.new("Other Street", 38.779536, -123.401503))
          ],
          [
            VW::CustomField.new("Note1", "Value1"),
            VW::CustomField.new("Note2", "Value2"),
          ]
        )
        @job = @job.create
        r_job = VW::Job.show(@job.id)
        r_job.custom_fields.should == @job.custom_fields
      end

      it "Creates and assigns a job" do
        @worker = VW::Worker.new("Joe", "joe@example.com")
        @worker = @worker.create
        
        @job = VW::Job.new("Joe", "Std Delivery", 60,
        [
          VW::Step.new("Start", VWorkApp::Location.new("880 Harrison St", 37.779536, -122.401503)),
          VW::Step.new("End",   VWorkApp::Location.new("Other Street", 38.779536, -123.401503))
        ], nil, nil, @worker.id, DateTime.parse("2012-12-25 16:30"))
        @job = @job.create
        r_job = VW::Job.show(@job.id)

        r_job.worker_id.should == @worker.id
        r_job.planned_start_time.should == DateTime.parse("2012-12-25 16:30")
      end
      
    end

    after(:each) do
      @job.delete if @job
      @worker.delete if @worker
    end

  end

  # context "With a known job" do
  #   before(:each) do
  #     @worker = VW::Worker.new("Joe", "joe@example.com")
  #     @worker = @worker.create
  #   end
  # 
  #   after(:each) do
  #     @worker.delete
  #   end
  # 
  #   describe "#show" do 
  #     it "Returns the worker" do
  #       r_worker = VW::Worker.show(@worker.id)
  #       r_worker.name.should == "Joe"
  #       r_worker.email.should == "joe@example.com"
  #     end
  # 
  #     it "Returns nil if not found" do
  #       pending("Bug in vWorkApp. Should be returning a 404 but isn't")
  #       r_worker = VW::Worker.show(-1)
  #       r_worker.should be_nil
  #     end
  #   end
  # 
  #   describe "#update" do
  #     it "Updates the worker" do
  #       @worker.name = "Joe2"
  #       @worker.email = "joe2@example.com"
  #       @worker.update
  #       r_worker = VW::Worker.show(@worker.id)
  #       r_worker.name.should == "Joe2"
  #       r_worker.email.should == "joe2@example.com"
  #     end
  #   end
  # 
  #   describe "#delete" do
  #     it "Deletes the worker" do
  #       @worker.delete
  #       # XXX Can't verify until #show is fixed
  #       # r_worker = VW::Worker.show(@worker.id)
  #       # r_worker.should be_nil
  #     end
  #   end
  # 
  #   describe "#find" do
  #     it "Finds all workers" do
  #       results = VW::Worker.find
  #       results.should be_instance_of(Array)
  #       results.should include(@worker)
  #     end
  #   end
  #   
  # end



end
