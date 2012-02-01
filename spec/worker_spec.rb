require "vworkapp_ruby"

describe VW::Worker do

  before(:all) do
    VW::Worker.base_uri 'https://api.staging.vworkapp.com/api/2.0'
    VW.api_key = "AtuogECLCV2R7uT-fkPg"
  end

  context "Without a known worker" do

    describe "#Create" do      
      it "Assigns the new worker an id" do
        @worker = VW::Worker.new(:name => "Joe", :email => "joe@example.com")
        @worker = @worker.create
        @worker.id.should_not be_nil
      end

      it "Creates a worker" do
        @worker = VW::Worker.new(:name => "Joe", :email => "joe@example.com")
        @worker = @worker.create
        r_worker = VW::Worker.show(@worker.id)
        r_worker.name.should == @worker.name
        r_worker.email.should == @worker.email
      end
      
    end

    after(:each) do
      @worker.delete if @worker
    end

  end

  context "With a known worker" do
    before(:each) do
      @worker = VW::Worker.new(:name => "Joe", :email => "joe@example.com")
      @worker = @worker.create
    end
  
    after(:each) do
      @worker.delete
    end
  
    describe "#Show" do 
      it "Returns the worker" do
        r_worker = VW::Worker.show(@worker.id)
        r_worker.name.should == "Joe"
        r_worker.email.should == "joe@example.com"
      end
  
      it "Returns nil if not found" do
        pending("Bug in vWorkApp. Should be returning a 404 but isn't")
        r_worker = VW::Worker.show(-1)
        r_worker.should be_nil
      end
    end
  
    describe "#Update" do
      it "Updates the worker" do
        @worker.name = "Joe2"
        @worker.email = "joe2@example.com"
        @worker.update
        r_worker = VW::Worker.show(@worker.id)
        r_worker.name.should == "Joe2"
        r_worker.email.should == "joe2@example.com"
      end
    end

    describe "#Delete" do
      it "Deletes the worker" do
        @worker.delete
        # XXX Can't verify until #show is fixed
        # r_worker = VW::Worker.show(@worker.id)
        # r_worker.should be_nil
      end
    end

    describe "#Find" do
      it "Finds all workers" do
        results = VW::Worker.find()
        results.should be_instance_of(Array)
        results.should include(@worker)
      end
    end
    
  end

end
