module VWorkApp
  class Contact < Base
    hattr_accessor :first_name, :last_name, :phone, :mobile, :email, :location
    self.include_root_in_json = false
  
    def ==(other)
      attributes_eql?(other, :first_name, :last_name, :phone, :mobile, :email, :location)
    end
  
  end
end