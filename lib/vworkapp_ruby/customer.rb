module VWorkApp

  class Customer < Base  
    attr_accessor :id, :third_party_id, :name, :site_contact, :billing_contact
  
    #---------------
    # Object Methods
    #---------------

    def initialize(name, id = nil, third_party_id = nil, site_contact = nil, billing_contact = nil)
      @name = name
      @id = id
      @third_party_id = third_party_id
      @site_contact = site_contact
      @billing_contact = billing_contact
    end
    
    def self.from_hash(attributes)
      customer = Customer.new(attributes["name"], attributes["id"], attributes["third_party_id"])
      customer.site_contact = Contact.from_hash(attributes["delivery_contact"])
      customer.billing_contact = Contact.from_hash(attributes["billing_contact"])
      customer
    end

    def to_hash
      cust_hash = { :customer => { :name  => self.name } }
      cust_hash[:customer][:third_party_id] = self.third_party_id if third_party_id
      cust_hash[:customer][:delivery_contact] = self.site_contact.to_hash if site_contact
      cust_hash[:customer][:billing_contact] = self.billing_contact.to_hash if billing_contact
      cust_hash
    end

    def ==(other)
      attributes_eql?(other, [:id, :name, :third_party_id, :site_contact, :billing_contact])
    end
    
    #---------------
    # REST Methods
    #---------------

    def create
      perform(:post, "/customers.xml", {}, self.to_hash) do |res|
        Customer.from_hash(res["customer"])
      end
    end

    def update(use_third_party_id = false)
      perform(:put, "/customers/#{id}.xml", { :use_third_party_id => use_third_party_id }, self.to_hash)
    end

    def delete(use_third_party_id = false)
      perform(:delete, "/customers/#{id}.xml", { :use_third_party_id => use_third_party_id })
    end

    def self.show(id, use_third_party_id = false)
      perform(:get, "/customers/#{id}.xml", :use_third_party_id => use_third_party_id) do |res|
        Customer.from_hash(res["customer"])
      end
    end    

    def self.find      
      self.perform(:get, "/customers.xml") do |res|
        res["customers"].map { |h| Customer.from_hash(h) }
      end
    end
      
  end

  class Contact < Base
    include AttributeEquality
    attr_accessor :first_name, :last_name, :phone, :mobile, :email, :location
    
    def initialize(first_name = nil, last_name = nil, phone = nil, mobile = nil, email = nil, location = nil)
      @first_name = first_name 
      @last_name = last_name
      @phone = phone
      @mobile = mobile
      @email = email
      @location = location
    end

    def self.from_hash(attributes)
      contact = Contact.new(attributes["first_name"], attributes["last_name"], attributes["phone"], attributes["mobile"], attributes["email"])
      contact.location = Location.from_hash(attributes["location"])
      contact
    end

    def to_hash
      contact_hash = { 
        :first_name  => self.first_name,
        :last_name  => self.last_name,
        :phone  => self.phone,
        :mobile  => self.mobile,
        :email => self.email
      }
      contact_hash[:location] = self.location.to_hash if location
      contact_hash
    end
    
    def ==(other)
      attributes_eql?(other, [:first_name, :last_name, :phone, :mobile, :email, :location])
    end
    
  end

end