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
end
