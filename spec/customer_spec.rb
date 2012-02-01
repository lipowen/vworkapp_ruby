require "vworkapp_ruby"

describe VW::Customer do

  before(:all) do
    VW::Customer.base_uri 'https://api.staging.vworkapp.com/api/2.0'
    VW.api_key = "AtuogECLCV2R7uT-fkPg"
  end

  context "Without a known customer" do

    describe "#Create" do
      
      it "Assigns the new customer an id" do
        @customer = VW::Customer.new(:name => "Joe's Baked Goods")
        @customer = @customer.create
        @customer.id.should_not be_nil
      end

      it "Creates a customer" do
        @customer = VW::Customer.new(:name => "Joe's Baked Goods", :third_party_id => "My ID")
        @customer = @customer.create

        r_cust = VW::Customer.show(@customer.id)
        r_cust.name.should == @customer.name
        r_cust.third_party_id.should == @customer.third_party_id
      end

      it "Creates a customer with a billing and delivery contact" do
        @customer = VW::Customer.new(
          :name => "Joe's Baked Goods", 
          :third_party_id => "My ID", 
          :delivery_contact => {
            :first_name => "Joe",
            :last_name => "Fisher",
            :phone => "415-465-8888",
            :mobile => "415-465-9999",
            :email => "joe@bakary.com"
          },
          :billing_contact => {
            :first_name => "Felix", 
            :last_name => "Smith"
          }
        )
        @customer = @customer.create
      
        r_cust = VW::Customer.show(@customer.id)
        
        r_cust.delivery_contact.should == @customer.delivery_contact
        r_cust.billing_contact.should == @customer.billing_contact
      end

      it "Creates a customer with a contact location" do
        pending "Can't pass a location object in yet. API should support this"
        site = VW::Location.from_address("880 Harrison St, SF, USA")
        @customer = VW::Customer.new("Joe's Baked Goods", nil, "My ID", VW::Contact.new("Joe", "Fisher", nil, nil, nil, site))
        @customer = @customer.create
      
        r_cust = VW::Customer.show(@customer.id)
        r_cust.delivery_contact.location.should == site    
      end
      
    end

    after(:each) do
      @customer.delete if @customer
    end

  end

  context "With a known customer" do
    before(:each) do
      @customer = VW::Customer.new(:name => "Joe's Baked Goods")
      @customer = @customer.create
    end
  
    after(:each) do
      @customer.delete
    end
  
    describe "#Show" do 
      it "Returns the customer" do
        r_cust = VW::Customer.show(@customer.id)
        r_cust.name.should == "Joe's Baked Goods"
      end
  
      it "Returns nil if not found" do
        r_customer = VW::Customer.show(-1)
        r_customer.should be_nil
      end
    end
  
    describe "#Update" do
      
      it "Updates a customer's primary details" do
        @customer.name = "Jeff's Canned Beans"
        @customer.third_party_id = "My Other ID"
        @customer.update
        r_cust = VW::Customer.show(@customer.id)
        r_cust.name.should == "Jeff's Canned Beans"
        r_cust.third_party_id.should == "My Other ID"
      end

      it "Updates a customers delivery and billing contacts" do
        delivery_contact = VW::Contact.new(:first_name => "Joe", :last_name => "Fisher", :phone => "415-465-8888", :mobile => "415-465-9999", :email => "joe@bakary.com")
        billing_contact = VW::Contact.new(:first_name => "Felix", :last_name => "Smith")
        @customer.delivery_contact = delivery_contact
        @customer.billing_contact = billing_contact
        @customer.update

        r_cust = VW::Customer.show(@customer.id)
        r_cust.delivery_contact.should == delivery_contact
        r_cust.billing_contact.should == billing_contact
      end

    end

    describe "#Delete" do
      it "Deletes the customer" do
        @customer.delete
        r_customer = VW::Customer.show(@customer.id)
        r_customer.should be_nil
      end
    end

    describe "#Find" do
      it "Finds all customers" do
        results = VW::Customer.find
        results.should be_instance_of(Array)
        results.should include(@customer)
      end
    end
    
  end

end
