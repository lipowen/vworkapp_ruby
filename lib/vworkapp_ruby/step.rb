module VWorkApp
  class Step < Base
    hattr_accessor :name, {:location => VWorkApp::Location}, :completed_at
    self.include_root_in_json = false

    def ==(other)
      attributes_eql?(other, :name, :location, :completed_at)
    end
  
  end
end