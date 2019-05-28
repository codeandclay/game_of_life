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

  # An indiviudal cell.
  # It is aware of its own state and the state of its neighbours.
  class Cell
    def initialize(state:)
      @state = state
    end

    attr_accessor :state

    def self.new_with_random_state
      GameOfLife::Cell.new(state: States.random)
    end
  end

  # Represent the two dimensional grid on which the cells are placed.
  class Grid
    def initialize(size, &block)
      @size = size
      @block = block
    end

    def to_a
      @to_a ||= Array.new(size) { Array.new(size) { block.call } }
    end

    def self.new_random(size:)
      Grid.new(size) { Cell.new_with_random_state }
    end

    # Returns a new grid from a given grid. A block may be given to transform
    # each item in the grid.
    def self.new_from(grid:)
      grid.map do |row|
        row.map do |cell|
          next cell unless block_given?

          yield cell
        end
      end
    end

    private

    attr_accessor :size, :block
  end
end
