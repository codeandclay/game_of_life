# frozen_string_literal: true

class GameOfLife
  # Determines the neigbouring items of a coordinate in a two dimensional grid
  # where the columns and rows wrap.
  class Neighbours
    def initialize(coordinates:, grid:)
      @row, @column = coordinates
      @grid = grid
    end

    def to_a
      @to_a = local_group.reject.with_index { |_, i| i == 4 }
    end

    def count
      to_a.count
    end

    private

    attr_accessor :grid, :row, :column

    # The original cell plus the 8 cells that surround it
    def local_group
      (grid.to_a * 3)[row_before, 3].flat_map do |grid_row|
        (grid_row.to_a * 3)[column_before, 3]
      end
    end

    def row_before
      grid.size + (row - 1)
    end

    def column_before
      grid.size + (column - 1)
    end
  end
end
