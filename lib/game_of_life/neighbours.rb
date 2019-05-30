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
      coordinates_of_neighbours.map do |coordinates|
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
