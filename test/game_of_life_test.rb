# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../game_of_life'

describe GameOfLife::States do
  it 'should report the expected state for alive' do
    GameOfLife::States.alive.must_equal :alive
  end

  it 'should report the expected state for dead' do
    GameOfLife::States.dead.must_equal :dead
  end

  it 'should return a random state' do
    GameOfLife::States::STATES.must_include GameOfLife::States.random
  end

  it 'should return a random state with a satisfactory randomness' do
    states = (0...100).to_a.map do
      GameOfLife::States.random
    end.uniq

    states.count.must_equal GameOfLife::States::STATES.count
  end
end

describe GameOfLife::Cell do
  before do
    @alive_state = GameOfLife::States.alive
    @dead_state = GameOfLife::States.dead
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

describe GameOfLife::Grid do
  before do
    @size = 15
    @random_grid = GameOfLife::Grid.new_random(size: @size)
  end

  it 'should create a two dimensional array' do
    # A grid of the dimension size will have size*size cells
    total_cell_count = @size * @size
    cells = @random_grid.flatten
    cells.count.must_equal total_cell_count
  end

  it 'should return a grid with a cell for each position' do
    # The total item count will equal the total GameOfLife::Cell count
    @random_grid.flatten.select do |item|
      item.is_a?(GameOfLife::Cell)
    end.count.must_equal @random_grid.flatten.count
  end

  it 'should return a new grid when given an existing grid' do
    new_grid = GameOfLife::Grid.new_from(grid: @random_grid)
    new_grid.must_equal @random_grid
  end

  it 'should return a grid with values transformed when block is given' do
    grid_of_ones = Array.new(@size) { Array.new(@size, 1) }
    new_grid = GameOfLife::Grid.new_from(grid: @random_grid) { 1 }
    new_grid.must_equal grid_of_ones
  end
end
