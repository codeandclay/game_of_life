# frozen_string_literal: true

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
end
