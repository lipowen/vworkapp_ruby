module VWorkApp
  class Telemetry < Base
    hattr_accessor :lat, :lng, :recorded_at, :heading, :speed
    self.include_root_in_json = false
  end
end