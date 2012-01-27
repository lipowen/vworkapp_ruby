module VWorkApp

  class Step
    include AttributeMethods
    attr_accessor :name, :location, :completed_at
  
    def initialize(name, location = nil)
      @name = name
      @location = location
    end

    def attributes
      [:name, {:location => VW::Location}, :completed_at]
    end

    def ==(other)
      attributes_eql?(other, [:name, :location, :completed_at])
    end
  
  end

end