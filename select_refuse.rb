friends = %w[Sharon Leo Leila Brian Arun]
invited_list = []

friends.each do |friend|
  invited_list.push(friend) if friend != "Brian"
end

friends = %w[Sharon Leo Leila Brian Arun]

puts(friends.reject { |friend| friend == "Brian" })
#=> ["Sharon", "Leo", "Leila", "Arun"]

friends = %w[Sharon Leo Leila Brian Arun]

friends.reject { |friend| friend == "Brian" }
#=> ["Sharon", "Leo", "Leila", "Arun"]

friends = %w[Sharon Leo Leila Brian Arun]

friends.each { |friend| puts "Hello, #{friend}" }

#=> Hello, Sharon
#=> Hello, Leo
#=> Hello, Leila
#=> Hello, Brian
#=> Hello, Arun

#=> ["Sharon", "Leo", "Leila", "Brian" "Arun"]

my_array = [1, 2]

my_array.each do |num|
  num *= 2
  puts "The new number is #{num}."
end

#=> The new number is 2.
#=> The new number is 4.

#=> [1, 2]
