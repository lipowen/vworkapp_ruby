module VWorkApp
  class Customer < Resource  
    hattr_accessor :id, :third_party_id, :name, {:delivery_contact => VWorkApp::Contact}, {:billing_contact => VWorkApp::Contact}
  
    def ==(other)
      attributes_eql?(other, :id, :name, :third_party_id, :delivery_contact, :billing_contact)
    end
    
    # XXX Work around for API bug that doesn't accept a nil contact detail. 
    def to_xml(options = {})
      except = options[:except] || [] 
      except << "delivery_contact" unless delivery_contact 
      except << "billing_contact" unless billing_contact 
      super(:except => except)
    end

  end
end