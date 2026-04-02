# frozen_string_literal: true

class Mastermind
  COLORS = %w[1 2 3 4 5 6]
  CODE_LENGTH = 4
  MAX_TURNS = 12

  def initialize
    @turn = 1
    @won = false
    @computer_memory = Array.new(CODE_LENGTH)
  end

  def play
    puts "Choose role: [1] Guesser, [2] Creator"
    @role = gets.chomp

    if @role == '1'
      @secret_code = Array.new(CODE_LENGTH) { COLORS.sample }
    else
      puts "Enter your 4-digit secret code using numbers 1-6:"
      @secret_code = gets.chomp.chars
    end

    while @turn <= MAX_TURNS && !@won
      guess = @role == '1' ? human_guess : computer_guess
      puts "\nTurn #{@turn}: #{guess.join}"

      if guess == @secret_code
        @won = true
      else
        evaluate_guess(guess)
        @turn += 1
      end
    end

    declare_winner
  end

  private

  def human_guess
    puts "Enter 4 digits (1-6):"
    gets.chomp.chars
  end

  def computer_guess
    sleep(1)
    guess = Array.new(CODE_LENGTH)
    guess.each_with_index do |_, index|
      guess[index] = @computer_memory[index] || COLORS.sample
    end
    guess
  end

  def evaluate_guess(guess)
    exact = 0
    partial = 0
    temp_secret = @secret_code.dup
    temp_guess = guess.dup

    temp_guess.each_with_index do |peg, index|
      if peg == temp_secret[index]
        exact += 1
        @computer_memory[index] = peg if @role == '2'
        temp_secret[index] = nil
        temp_guess[index] = nil
      end
    end

    temp_guess.compact.each do |peg|
      if temp_secret.include?(peg)
        partial += 1
        temp_secret[temp_secret.index(peg)] = nil
      end
    end

    puts "Exact (right color and position): #{exact}"
    puts "Partial (right color, wrong position): #{partial}"
  end

  def declare_winner
    if @won
      puts @role == '1' ? "You guessed the secret code!" : "The computer broke your code!"
    else
      puts "Game over. The secret code was #{@secret_code.join}."
    end
  end
end

Mastermind.new.play