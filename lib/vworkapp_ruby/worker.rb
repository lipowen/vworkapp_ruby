module VWorkApp
  class Worker < Resource
    hattr_accessor :id, :name, :email, :third_party_id, :latest_telemetry
    hattr_reader :latest_telemetry => VWorkApp::Telemetry

    def ==(other)
      attributes_eql?(other, :id, :name, :email, :third_party_id)
    end
    
  end
end