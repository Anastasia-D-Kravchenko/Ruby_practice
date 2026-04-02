# frozen_string_literal: true

def fibs(n)
  return [] if n <= 0
  return [0] if n == 1

  sequence = [0, 1]
  while sequence.length < n
    sequence << sequence[-1] + sequence[-2]
  end
  sequence
end

def fibs_rec(n)
  puts 'This was printed recursively'
  return [] if n <= 0
  return [0] if n == 1
  return [0, 1] if n == 2

  sequence = fibs_rec(n - 1)
  sequence << sequence[-1] + sequence[-2]
end

p fibs(8)
p fibs_rec(8)