# frozen_string_literal: true

require 'yaml'
require 'faraday'
require 'json'

GROQ_API_KEY = 'api haha'

class ChessAI
  def self.get_move(board_string, valid_moves)
    return valid_moves.sample if GROQ_API_KEY.include?('your_groq')

    conn = Faraday.new(url: 'https://api.groq.com/openai/v1/chat/completions')
    response = conn.post do |req|
      req.headers['Authorization'] = "Bearer #{GROQ_API_KEY}"
      req.headers['Content-Type'] = 'json'
      req.body = {
        model: "llama-3.3-70b-versatile",
        messages: [
          { role: "system", content: "You are a chess expert. Given a board state and legal moves, pick the best one. Reply ONLY with the move (e.g., 'e2 e4')." },
          { role: "user", content: "Board:\n#{board_string}\nLegal Moves: #{valid_moves.join(', ')}" }
        ]
      }.to_json
    end

    JSON.parse(response.body).dig('choices', 0, 'message', 'content').strip
  rescue
    valid_moves.sample
  end
end

# --- Piece Logic ---
class Piece
  attr_reader :color, :symbol
  attr_accessor :pos

  def initialize(color, pos)
    @color = color
    @pos = pos
  end

  def to_s; @symbol; end

  def valid_moves(board)
    move_dirs.flat_map { |dir| explore_dir(dir, board) }
  end

  def explore_dir(dir, board)
    moves = []
    curr_x, curr_y = @pos
    loop do
      curr_x, curr_y = curr_x + dir[0], curr_y + dir[1]
      break unless curr_x.between?(0, 7) && curr_y.between?(0, 7)
      target = board.grid[curr_x][curr_y]
      if target.nil?
        moves << [curr_x, curr_y]
      elsif target.color != @color
        moves << [curr_x, curr_y]
        break
      else; break; end
      break if respond_to?(:single_step?)
    end
    moves
  end
end

class Knight < Piece
  def initialize(color, pos); super; @symbol = color == :white ? "♘" : "♞"; end
  def move_dirs; [[1,2],[1,-2],[-1,2],[-1,-2],[2,1],[2,-1],[-2,1],[-2,-1]]; end
  def single_step?; true; end
end

class King < Piece
  def initialize(color, pos); super; @symbol = color == :white ? "♔" : "♚"; end
  def move_dirs; [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]; end
  def single_step?; true; end
end

# --- Board & Game Logic ---
class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    setup_board
  end

  def setup_board
    # Simplified setup for demo
    @grid[7][1] = Knight.new(:white, [7, 1])
    @grid[0][1] = Knight.new(:black, [0, 1])
    @grid[7][4] = King.new(:white, [7, 4])
    @grid[0][4] = King.new(:black, [0, 4])
  end

  def move_piece(start, finish)
    piece = self[start]
    self[finish] = piece
    self[start] = nil
    piece.pos = finish if piece
  end

  def [](pos); @grid[pos[0]][pos[1]]; end
  def []=(pos, val); @grid[pos[0]][pos[1]] = val; end

  def to_s
    @grid.map { |row| row.map { |p| p ? p.symbol : "." }.join(" ") }.join("\n")
  end
end

class ChessGame
  def initialize
    @board = Board.new
    @turn = :white
  end

  def play
    loop do
      puts "\n#{@board}"
      puts "#{@turn.capitalize}'s turn."

      if @turn == :black # AI Turn
        legal_moves = get_all_legal_moves(:black)
        move_str = ChessAI.get_move(@board.to_s, legal_moves)
        puts "AI chooses: #{move_str}"
        execute_move(move_str)
      else # Human Turn
        print "Enter move (e.g., b1 c3) or 'save': "
        input = gets.chomp
        save_game if input == 'save'
        execute_move(input)
      end
      @turn = @turn == :white ? :black : :white
    end
  end

  def execute_move(str)
    # Simple parser: "b1 c3" -> [7,1] to [5,2]
    mapping = { 'a'=>0, 'b'=>1, 'c'=>2, 'd'=>3, 'e'=>4, 'f'=>5, 'g'=>6, 'h'=>7 }
    parts = str.split
    start = [8 - parts[0][1].to_i, mapping[parts[0][0]]]
    finish = [8 - parts[1][1].to_i, mapping[parts[1][0]]]
    @board.move_piece(start, finish)
  end

  def get_all_legal_moves(color)
    moves = []
    @board.grid.each_with_index do |row, r|
      row.each_with_index do |piece, c|
        if piece && piece.color == color
          piece.valid_moves(@board).each do |m|
            moves << "#{('a'.ord + c).chr}#{8-r} #{('a'.ord + m[1]).chr}#{8-m[0]}"
          end
        end
      end
    end
    moves
  end

  def save_game
    File.open("chess.yaml", "w") { |f| f.write(YAML.dump(self)) }
    puts "Saved!"
  end
end

ChessGame.new.play