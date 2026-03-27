friends = %w[Sharon Leo Leila Brian Arun]

puts(friends.select(&:upcase))
puts
puts(friends.map(&:upcase))
#=> `['SHARON', 'LEO', 'LEILA', 'BRIAN', 'ARUN']`

friends = %w[Sharon Leo Leila Brian Arun]

friends.map(&:upcase)
#=> `['SHARON', 'LEO', 'LEILA', 'BRIAN', 'ARUN']`
#=> ['Sharon', 'Leo', 'Leila', 'Brian', 'Arun']

friends = %w[Sharon Leo Leila Brian Arun]

friends.map!(&:upcase)
#=> `['SHARON', 'LEO', 'LEILA', 'BRIAN', 'ARUN']`

friends
#=> `['SHARON', 'LEO', 'LEILA', 'BRIAN', 'ARUN']`
