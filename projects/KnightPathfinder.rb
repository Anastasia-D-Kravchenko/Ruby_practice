# frozen_string_literal: true

class KnightPathfinder
  MOVES = [
    [1, 2], [1, -2], [-1, 2], [-1, -2],
    [2, 1], [2, -1], [-2, 1], [-2, -1]
  ].freeze

  def knight_moves(start, target)
    return [start] if start == target

    queue = [[start, [start]]]
    visited = Set.new([start])

    until queue.empty?
      current_pos, path = queue.shift

      possible_moves(current_pos).each do |next_move|
        next if visited.include?(next_move)

        new_path = path + [next_move]
        return display_results(new_path) if next_move == target

        visited.add(next_move)
        queue << [next_move, new_path]
      end
    end
  end

  private

  def possible_moves(pos)
    x, y = pos
    MOVES.map { |dx, dy| [x + dx, y + dy] }
         .select { |nx, ny| nx.between?(0, 7) && ny.between?(0, 7) }
  end

  def display_results(path)
    puts "You made it in #{path.length - 1} moves! Here's your path:"
    path.each { |step| p step }
    path
  end
end

# Usage
require 'set'
pathfinder = KnightPathfinder.new
pathfinder.knight_moves([3, 3], [4, 3])