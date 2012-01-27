module VWorkApp

  class Telemetry
    include AttributeMethods
    attr_accessor :lat, :lng, :recorded_at, :heading, :speed
  
    def initialize (lat, lng, recorded_at, heading, speed)
      @lat = lat
      @lng = lng
      @recorded_at = recorded_at
      @heading = heading
      @speed = speed
    end

    def attributes
      [:lat, :lng, :recorded_at, :heading, :speed]
    end
  
  end

end