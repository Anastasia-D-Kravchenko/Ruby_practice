# frozen_string_literal: true

my_numbers = [5, 6, 7, 8]

puts my_numbers.reduce { |sum, number| sum + number }
#=> 26

my_numbers = [5, 6, 7, 8]

puts my_numbers.reduce(1000) { |sum, number| sum + number }
#=> 1026
