module VWorkApp
  class CustomField < Base
    hattr_accessor :name, :value
    self.include_root_in_json = false
      
    def ==(other)
      attributes_eql?(other, :name, :value)
    end

  end
end