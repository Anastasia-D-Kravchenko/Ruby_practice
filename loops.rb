# frozen_string_literal: true

l = 0

loop do
  puts "i = #{l}"
  l += 1
  break if l == 10
end

# while gets.chomp != "yes" do
#   puts "Are we there yet?"
# end

i = 0
until i == 10 do
  puts "i = #{i}"
  i += 1
end

puts(1..5)

for i in 1..5 do
  puts "i = #{i}"
end

5.times do
  puts "hi, sunny"
end


5.times do |number|
  puts "Alternative fact number #{number}"
end

5.upto(10) { |num| print "#{num} " }     #=> 5 6 7 8 9 10

10.downto(5) { |num| print "#{num} " }   #=> 10 9 8 7 6 5
