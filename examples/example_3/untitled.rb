module Animal
  def walk
    puts "plinc blonc " * 2
  end
end

module Person
  include Animal
end

class Plumber
  include Animal
  extend Person
end

Plumber.new.walk
Plumber.walk
