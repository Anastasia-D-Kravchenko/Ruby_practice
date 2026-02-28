# frozen_string_literal: true

def isogram?(string)
  original_length = string.length
  string_array = string.downcase.split
  unique_length = string_array.uniq.length
  original_length == unique_length
end

isogram?("Odin")

#=> false


require 'pry-byebug'

def isogram?(string)
  original_length = string.length
  string_array = string.downcase.split

  binding.pry

  unique_length = string_array.uniq.length
  original_length == unique_length
end

isogram?("Odin")


require 'pry-byebug' # 1. Tell Ruby to load the gem we just installed

def calculate_total(price, tax)
  total = price + (price * tax)

  binding.pry # 2. THIS IS THE MAGIC PAUSE BUTTON

  return total
end

puts "Starting calculation..."
calculate_total(100, 0.05)
puts "Calculation finished!"


