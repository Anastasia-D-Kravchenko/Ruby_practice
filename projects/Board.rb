# frozen_string_literal: true

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(6) { Array.new(7, ' ') }
  end

  def drop_token(column, token)
    return false unless column.between?(0, 6)

    5.downto(0) do |row|
      if @grid[row][column] == ' '
        @grid[row][column] = token
        return true
      end
    end
    false
  end

  def win?(token)
    horizontal_win?(token) || vertical_win?(token) || diagonal_win?(token)
  end

  def full?
    @grid.flatten.none?(' ')
  end

  def display
    puts "\n"
    @grid.each do |row|
      puts "|#{row.join('|')}|"
    end
    puts "+-+-+-+-+-+-+-+"
    puts " 0 1 2 3 4 5 6 \n\n"
  end

  private

  def horizontal_win?(token)
    @grid.any? do |row|
      row.each_cons(4).any? { |line| line.all?(token) }
    end
  end

  def vertical_win?(token)
    @grid.transpose.any? do |col|
      col.each_cons(4).any? { |line| line.all?(token) }
    end
  end

  def diagonal_win?(token)
    (0..2).any? do |row|
      (0..3).any? do |col|
        [@grid[row][col], @grid[row+1][col+1], @grid[row+2][col+2], @grid[row+3][col+3]].all?(token)
      end
    end ||
      (0..2).any? do |row|
        (3..6).any? do |col|
          [@grid[row][col], @grid[row+1][col-1], @grid[row+2][col-2], @grid[row+3][col-3]].all?(token)
        end
      end
  end
end

class Game
  def initialize
    @board = Board.new
    @players = [{ name: "Player 1", token: "\u26AA" }, { name: "Player 2", token: "\u26AB" }]
    @current_player = @players.first
  end

  def play
    loop do
      @board.display
      column = get_move

      unless @board.drop_token(column, @current_player[:token])
        puts "Column full or invalid. Try again."
        next
      end

      if @board.win?(@current_player[:token])
        @board.display
        puts "#{@current_player[:name]} wins!"
        break
      elsif @board.full?
        @board.display
        puts "It's a draw!"
        break
      end

      switch_player
    end
  end

  private

  def get_move
    loop do
      puts "#{@current_player[:name]} (#{@current_player[:token]}), choose a column (0-6):"
      input = gets.chomp
      return input.to_i if input.match?(/^[0-6]$/)
      puts "Invalid input."
    end
  end

  def switch_player
    @current_player = @current_player == @players.first ? @players.last : @players.first
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end