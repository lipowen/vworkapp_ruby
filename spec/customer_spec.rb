require "vworkapp_ruby"

describe VW::Customer do

  before(:all) do
    VW::Customer.base_uri 'api.staging.vworkapp.com/api/2.0'
    VW.api_key = "AtuogECLCV2R7uT-fkPg"
  end

  context "Without a known customer" do

    describe "#Equals" do

      it "Is equal to another customer if it has the same key attributes" do
        customer_1 = VW::Customer.new("Joe's Baked Goods", 100, 200, 
          VW::Contact.new("Joe", "Fisher", "415-465-8888", "415-465-9999", "joe@bakary.com"),
          VW::Contact.new("Bob", "Jones", "021-465-2342", "233-233-1242", "bob.jones@jones.com")
        )
        customer_2 = VW::Customer.new("Joe's Baked Goods", 100, 200, 
          VW::Contact.new("Joe", "Fisher", "415-465-8888", "415-465-9999", "joe@bakary.com"),
          VW::Contact.new("Bob", "Jones", "021-465-2342", "233-233-1242", "bob.jones@jones.com")
        )
        customer_1.should == customer_2
      end

      it "Isn't equal to another worker if doesn't share the key attributes" do
        customer_1 = VW::Customer.new("Joe's Baked Goods", 100, 200, 
          VW::Contact.new("Joe", "Fisher", "415-465-8888", "415-465-9999", "joe@bakary.com"),
          VW::Contact.new("Bob", "Jones", "021-465-2342", "233-233-1242", "bob.jones@jones.com")
        )
        customer_2 = VW::Customer.new("Joe's Baked Goods", 100, 200, 
          VW::Contact.new("Joe", "Fisher", "415-465-8888", "415-465-9999", "joe@bakary.com"),
          VW::Contact.new("Jeff", "Jones", "021-465-2342", "233-233-1242", "bob.jones@jones.com")
        )
        customer_1.should_not == customer_2
      end

    end

    describe "#Create" do
      
      it "Assigns the new customer an id" do
        @customer = VW::Customer.new("Joe's Baked Goods")
        @customer = @customer.create
        @customer.id.should_not be_nil
      end

      it "Creates a customer" do
        @customer = VW::Customer.new("Joe's Baked Goods", nil, "My ID")
        @customer = @customer.create
      
        r_cust = VW::Customer.show(@customer.id)
        r_cust.name.should == @customer.name
        r_cust.third_party_id.should == @customer.third_party_id
      end

      it "Creates a customer with a billing and delivery contact" do
        site_contact = VW::Contact.new("Joe", "Fisher", "415-465-8888", "415-465-9999", "joe@bakary.com")
        billing_contact = VW::Contact.new("Felix", "Smith")
        @customer = VW::Customer.new("Joe's Baked Goods", nil, "My ID", site_contact, billing_contact)
        @customer = @customer.create
      
        r_cust = VW::Customer.show(@customer.id)
        
        r_cust.site_contact.should == site_contact        
        r_cust.billing_contact.should == billing_contact
      end

      it "Creates a customer with a contact location" do
        pending "Can't pass a location object in yet. API should support this"
        site = VW::Location.from_address("880 Harrison St, SF, USA")
        @customer = VW::Customer.new("Joe's Baked Goods", nil, "My ID", VW::Contact.new("Joe", "Fisher", nil, nil, nil, site))
        @customer = @customer.create
      
        r_cust = VW::Customer.show(@customer.id)
        r_cust.site_contact.location.should == site    
      end
      
    end

    after(:each) do
      @customer.delete if @customer
    end

  end

  context "With a known customer" do
    before(:each) do
      @customer = VW::Customer.new("Joe's Baked Goods")
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

      it "Updates a customers site and billing contacts" do
        site_contact = VW::Contact.new("Joe", "Fisher", "415-465-8888", "415-465-9999", "joe@bakary.com")
        billing_contact = VW::Contact.new("Felix", "Smith")
        @customer.site_contact = site_contact
        @customer.billing_contact = billing_contact
        @customer.update

        r_cust = VW::Customer.show(@customer.id)
        r_cust.site_contact.should == site_contact
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
