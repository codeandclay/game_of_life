# frozen_string_literal: true

class GameOfLife
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
end
