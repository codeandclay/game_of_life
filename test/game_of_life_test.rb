# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../game_of_life'

describe GameOfLife do
  describe GameOfLife::State do
    it 'should report the expected state for alive' do
      GameOfLife::State.alive.must_equal :alive
    end

    it 'should report the expected state for dead' do
      GameOfLife::State.dead.must_equal :dead
    end

    it 'should return a random state' do
      GameOfLife::State::STATES.must_include GameOfLife::State.random
    end

    it 'should return a random state with a satisfactory randomness' do
      states = (0...100).to_a.map do
        GameOfLife::State.random
      end.uniq

      states.count.must_equal GameOfLife::State::STATES.count
    end
  end

  describe GameOfLife::Cell do
    before do
      @alive_state = GameOfLife::State.alive
      @dead_state = GameOfLife::State.dead
    end

    it 'should report the expected state when alive' do
      cell = GameOfLife::Cell.new(state: @alive_state)
      cell.state.must_equal @alive_state
    end

    it 'should report the expected states when dead' do
      cell = GameOfLife::Cell.new(state: @dead_state)
      cell.state.must_equal @dead_state
    end

    it 'should generate a cell with a random state' do
      cell = GameOfLife::Cell.new_with_random_state
      [@alive_state, @dead_state].must_include cell.state
    end
  end
end
