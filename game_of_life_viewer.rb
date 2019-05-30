# frozen_string_literal: true

require_relative 'lib/game_of_life'
require 'tty-cursor'
require 'pry'
$stdout.sync = true

grid_size = 40
grid = GameOfLife::Grid.new_random(size: grid_size)

def squares
  {
    GameOfLife::States.alive => '██',
    GameOfLife::States.dead => '▒▒'
  }
end

def print_grid(grid)
  cursor = TTY::Cursor

  grid.to_a.each do |row|
    row.each do |cell|
      print squares[cell.state]
    end
    print "\n" + cursor.backward(grid.size)
  end
  print cursor.up(grid.size)
end

# print_grid(grid)

loop do
  print_grid(grid)
  old_grid = grid

  # Get the next state
  grid = GameOfLife::Grid.new_from(grid: old_grid) do |row, col|
    old_grid.to_a[row][col].subsequent_state(
      neighbours: GameOfLife::Neighbours.new(
        coordinates: [row, col], grid: old_grid
      )
    )
  end
  # sleep(0.2)
end
