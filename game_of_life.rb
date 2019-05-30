# frozen_string_literal: true

# Conway's GameOfLife
# ===================
#
# From Wikipedia: The universe of the Game of Life is an infinite,
# two-dimensional orthogonal grid of square cells, each of which is in one of
# two possible states, alive or dead, (or populated and unpopulated,
# respectively). Every cell interacts with its eight neighbours, which are the
# cells that are horizontally, vertically, or diagonally adjacent. At each step
# in time, the following transitions occur:
#
# 1. Any live cell with fewer than two live neighbours dies, as if by
# underpopulation.
#
# 2. Any live cell with two or three live neighbours lives on to the next
# generation.
#
# 3. Any live cell with more than three live neighbours dies, as if by
# overpopulation.
#
# 4. Any dead cell with exactly three live neighbours becomes a live cell, as if
# by reproduction.
#
# The initial pattern constitutes the seed of the system. The first generation
# is created by applying the above rules simultaneously to every cell in the
# seed; births and deaths occur simultaneously, and the discrete moment at which
# this happens is sometimes called a tick. Each generation is a pure function of
# the preceding one. The rules continue to be applied repeatedly to create
# further generations.
class GameOfLife
  # When initialising a new cell, this class can be used when defining its
  # state.
  # Each cell has a state: :alive or :dead
  module States
    STATES = %i[alive dead].freeze

    STATES.each do |state|
      define_singleton_method(state) do
        state
      end
    end

    def self.random
      STATES.sample
    end
  end

  # An indiviudal cell. It is aware of its own state. To create a cell with
  # the subsequent state, it needs to know its neighbours' states.
  class Cell
    def initialize(state:)
      @state = state
    end

    def alive?
      state == States.alive
    end

    def dead?
      state == States.dead
    end

    attr_accessor :state

    def self.new_with_random_state
      GameOfLife::Cell.new(state: States.random)
    end

    # Expects a cell object and an array of neighbours
    def subsequent_state(neighbours:)
      alive_neighbours = neighbours.count(&:alive?)

      # Any live cell with two or three live neighbours lives on to the next
      # generation.
      if alive? && alive_neighbours >= 2 && alive_neighbours <= 3
        return self.class.new(state: States.alive)
      end

      # Any dead cell with exactly three live neighbours becomes a live cell,
      # as if by reproduction
      return self.class.new(state: States.alive) if alive_neighbours == 3 && dead?

      # Any live cell with fewer than two live neighbours dies, as if by
      # underpopulation.
      # Any live cell with more than three live neighbours dies, as if by
      # overpopulation.
      self.class.new(state: States.dead)
    end
  end

  # Represent the two dimensional grid on which the cells are placed.
  class Grid
    def initialize(size, &block)
      @size = size
      @block = block
    end

    def to_a
      @to_a ||= Array.new(size) do |row|
        Array.new(size) { |col| block&.call(row, col) }
      end
    end

    # Maps items to the coordinates of their grid cells.
    # eg: `obj => [1, 1]`
    def to_h
      @to_h ||= to_a.flat_map.with_index do |row, row_index|
        row.map.with_index do |cell_item, column_index|
          { cell_item => [row_index, column_index] }
        end
      end.reduce(&:merge)
    end

    def coordinates_of(item)
      to_h[item]
    end

    def self.new_random(size:)
      Grid.new(size) { Cell.new_with_random_state }
    end

    # Returns a new grid from a given grid. A block may be given to transform
    # each item in the grid. The block has access to row and col parameters.
    def self.new_from(grid:, &block)
      return new(grid.size) unless block_given?

      new(grid.size, &block)
    end

    attr_accessor :size

    private

    attr_accessor :block
  end

  # Determines the neigbouring items of a coordinate in a two dimensional grid
  # where the columns and rows wrap.
  class Neighbours
    def initialize(coordinates:, grid:)
      @row, @column = coordinates
      @grid = grid
    end

    def to_a
      @to_a ||= coordinates_of_neighbours.map do |coordinates|
        grid.to_a[coordinates[0]][coordinates[1]]
      end
    end

    def count
      to_a.count
    end

    def coordinates_of_neighbours
      local_group - [[row, column]]
    end

    private

    attr_accessor :grid, :row, :column

    # Coordinates of original grid cell and its neighbours.
    # (Columns and rows wrap.)
    def local_group
      @local_group ||= (-1..1).flat_map do |row_rotation|
        rotated_row = row_axis.rotate(row_rotation)
        (-1..1).map do |column_rotation|
          rotated_column = column_axis.rotate(column_rotation)
          [rotated_row[row], rotated_column[column]]
        end
      end
    end

    def row_axis
      (0...grid.to_a.count).to_a
    end

    def column_axis
      (0...grid.to_a[0].count).to_a
    end
  end
end
