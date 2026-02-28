# frozen_string_literal: true

def caesar_cipher(string, shift)
  shifted_array = string.chars.map do |char|
    if char.ord.between?(65, 90)
      (((char.ord - 65) + shift) % 26 + 65).chr
    elsif char.ord.between?(97, 122)
      (((char.ord - 97) + shift) % 26 + 97).chr
    else
      char
    end
  end
  shifted_array.join
end

puts caesar_cipher("What a string!", 5)