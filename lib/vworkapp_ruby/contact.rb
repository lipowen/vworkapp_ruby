module VWorkApp
  class Contact
    include AttributeMethods
    attr_accessor :first_name, :last_name, :phone, :mobile, :email, :location
  
    def initialize(first_name = nil, last_name = nil, phone = nil, mobile = nil, email = nil, location = nil)
      @first_name = first_name 
      @last_name = last_name
      @phone = phone
      @mobile = mobile
      @email = email
      @location = location
    end
    
    def attributes
      [:first_name, :last_name, :phone, :mobile, :email, {:location => VW::Location}]
    end
  
    def ==(other)
      attributes_eql?(other, [:first_name, :last_name, :phone, :mobile, :email, :location])
    end
  
  end
end