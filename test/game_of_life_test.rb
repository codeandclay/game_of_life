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
  end
end
