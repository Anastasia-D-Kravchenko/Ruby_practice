# You're in the root of the project, the directory that holds main.rb

# This is your file structure:
├── lib
│    ├── flight.rb
│    ├── hotel.rb
│    └── airport.rb
└── main.rb

# lib/airport.rb
class Airport
  def introduce
    puts "I'm at the airport!"
  end
end

# lib/flight.rb
class Flight
  def introduce
    puts "I'm on the flight!"
  end
end

# lib/hotel.rb
class Hotel
  def introduce
    puts "I'm at the hotel!"
  end
end

# main.rb
require_relative 'lib/airport'
require_relative 'lib/flight'
require_relative 'lib/hotel'

Airport.new.introduce
#=> I'm at the airport!

Flight.new.introduce
#=> I'm on the flight!

Hotel.new.introduce
#=> I'm at the hotel!
# frozen_string_literal: true




