# frozen_string_literal: true

def substrings(string, dictionary)
  result = Hash.new(0)
  lowered_text = string.downcase
  dictionary.each do |word|
    matches = lowered_text.scan(word).length
    if matches > 0
      result[word] = matches
    end
  end
  result
end

dictionary = %w[below down go going horn how howdy it i low own part partner sit]

puts "Test 1 (Single Word):"
puts substrings("below", dictionary)
# Expected: {"below"=>1, "low"=>1}

puts "\nTest 2 (Multiple Words):"
puts substrings("Howdy partner, sit down! How's it going?", dictionary)
# Expected: {"down"=>1, "go"=>1, "going"=>1, "how"=>2, "howdy"=>1, "it"=>2, "i"=>3, "own"=>1, "part"=>1, "partner"=>1, "sit"=>1}