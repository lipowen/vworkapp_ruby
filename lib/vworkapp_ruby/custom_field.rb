module VWorkApp

  class CustomField
    include AttributeMethods
    attr_accessor :name, :value

    def initialize(name, value)
      @name = name
      @value = value
    end
    
    def attributes
      [:name, :value]
    end
  
    def ==(other)
      attributes_eql?(other, [:name, :value])
    end

  end

end