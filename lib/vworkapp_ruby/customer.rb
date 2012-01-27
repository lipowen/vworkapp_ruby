module VWorkApp

  class Customer < Resource  
    attr_accessor :id, :third_party_id, :name, :delivery_contact, :billing_contact
  
    #---------------
    # Object Methods
    #---------------

    def initialize(name, id = nil, third_party_id = nil, delivery_contact = nil, billing_contact = nil)
      @name = name
      @id = id
      @third_party_id = third_party_id
      @delivery_contact = delivery_contact
      @billing_contact = billing_contact
    end
    
    def attributes
      [:name, :id, :third_party_id, {:delivery_contact => VW::Contact}, {:billing_contact => VW::Contact}]
    end
    
    def to_hash
      { :customer => super.to_hash }
    end

    def ==(other)
      attributes_eql?(other, [:id, :name, :third_party_id, :delivery_contact, :billing_contact])
    end

    #---------------
    # REST Methods
    #---------------

    def create
      perform(:post, "/customers.xml", {}, to_hash) do |res|
        Customer.from_hash(res["customer"])
      end
    end

    def update(use_third_party_id = false)
      perform(:put, "/customers/#{id}.xml", { :use_third_party_id => use_third_party_id }, to_hash)
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

end