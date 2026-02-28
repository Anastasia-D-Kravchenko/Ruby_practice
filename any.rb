# frozen_string_literal: true

numbers = [21, 42, 303, 499, 550, 811]

numbers.any? { |number| number > 500 }
#=> true

numbers.any? { |number| number < 20 }
#=> false


fruits = %w[apple banana strawberry pineapple]

fruits.all? { |fruit| fruit.length > 3 }
#=> true

fruits.all? { |fruit| fruit.length > 6 }
#=> false


fruits = %w[apple banana strawberry pineapple]

fruits.none? { |fruit| fruit.length > 10 }
#=> true

fruits.none? { |fruit| fruit.length > 6 }
#=> false


fruits = %w[apple banana strawberry pineapple]

fruits.one? { |fruit| fruit.length > 9 }
#=> true

fruits.one? { |fruit| fruit.length > 2 }
#=> false
