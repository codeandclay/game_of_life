# frozen_string_literal: true

class GameOfLife
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
end
