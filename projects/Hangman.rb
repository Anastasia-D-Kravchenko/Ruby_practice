# frozen_string_literal: true

require 'yaml'

class Hangman
  def initialize
    @secret_word = select_word
    @guesses_left = 8
    @guessed_letters = []
    @board = Array.new(@secret_word.length, '_')
  end

  def start
    puts "[1] New Game\n[2] Load Game"
    gets.chomp == '2' ? load_game : play
  end

  def play
    until game_over?
      display_status
      input = get_input

      if input == 'save'
        save_game
        return
      else
        process_guess(input)
      end
    end
    end_game
  end

  private

  def select_word
    words = File.readlines('google-10000-english-no-swears.txt').map(&:chomp)
    words.select { |word| word.length.between?(5, 12) }.sample.downcase
  rescue Errno::ENOENT
    puts "Dictionary file not found. Defaulting to 'programming'."
    "programming"
  end

  def display_status
    puts "\nWord: #{@board.join(' ')}"
    puts "Guesses left: #{@guesses_left}"
    puts "Wrong letters: #{(@guessed_letters - @secret_word.chars).join(', ')}"
  end

  def get_input
    puts "Enter a letter to guess, or type 'save' to save the game:"
    input = gets.chomp.downcase
    until valid_input?(input)
      puts "Invalid input. Enter a single new letter, or 'save':"
      input = gets.chomp.downcase
    end
    input
  end

  def valid_input?(input)
    input == 'save' || (input.match?(/^[a-z]$/) && !@guessed_letters.include?(input))
  end

  def process_guess(letter)
    @guessed_letters << letter
    if @secret_word.include?(letter)
      @secret_word.chars.each_with_index do |char, index|
        @board[index] = letter if char == letter
      end
    else
      @guesses_left -= 1
    end
  end

  def game_over?
    @guesses_left.zero? || !@board.include?('_')
  end

  def end_game
    if @board.include?('_')
      puts "\nYou lost! The word was: #{@secret_word}"
    else
      puts "\nYou won! The word is: #{@secret_word}"
    end
  end

  def save_game
    Dir.mkdir('saves') unless Dir.exist?('saves')
    File.open('saves/save_game.yaml', 'w') { |file| file.write(YAML.dump(self)) }
    puts "Game saved!"
  end

  def load_game
    if File.exist?('saves/save_game.yaml')
      loaded_game = YAML.load_file('saves/save_game.yaml', permitted_classes: [Hangman])
      loaded_game.play
    else
      puts "No saved game found. Starting new game..."
      play
    end
  end
end

Hangman.new.start