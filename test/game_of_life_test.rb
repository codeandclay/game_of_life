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

  it 'should generate a live cell from a living cell when given two live neighbours' do
    neighbours = (1..2).map { GameOfLife::Cell.new(state: GameOfLife::States.alive) } +
                 (1..6).map { GameOfLife::Cell.new(state: GameOfLife::States.dead) }
    alive_cell = GameOfLife::Cell.new(state: GameOfLife::States.alive)
    subsequent_cell = GameOfLife::Cell.subsequent_state(cell: alive_cell, neighbours: neighbours)

    subsequent_cell.alive?.must_equal true
  end

  it 'should generate a live cell from a living cell when given three live neighbours' do
    neighbours = (1..3).map { GameOfLife::Cell.new(state: GameOfLife::States.alive) } +
                 (1..5).map { GameOfLife::Cell.new(state: GameOfLife::States.dead) }
    alive_cell = GameOfLife::Cell.new(state: GameOfLife::States.alive)
    subsequent_cell = GameOfLife::Cell.subsequent_state(cell: alive_cell, neighbours: neighbours)

    subsequent_cell.alive?.must_equal true
  end

  it 'should generate a live cell from a dead cell when given three live neighbours' do
    neighbours = (1..3).map { GameOfLife::Cell.new(state: GameOfLife::States.alive) } +
                 (1..5).map { GameOfLife::Cell.new(state: GameOfLife::States.dead) }
    dead_cell = GameOfLife::Cell.new(state: GameOfLife::States.dead)
    subsequent_cell = GameOfLife::Cell.subsequent_state(cell: dead_cell, neighbours: neighbours)

    subsequent_cell.alive?.must_equal true
  end

  it 'should generate a dead cell when given less than two live neighbours' do
    neighbours = [GameOfLife::Cell.new(state: GameOfLife::States.alive)] +
                 (1..7).map { GameOfLife::Cell.new(state: GameOfLife::States.dead) }
    dead_cell = GameOfLife::Cell.new(state: GameOfLife::States.dead)
    subsequent_cell = GameOfLife::Cell.subsequent_state(cell: dead_cell, neighbours: neighbours)

    subsequent_cell.dead?.must_equal true
  end

  it 'should generate a dead cell when given more than three live neighbours' do
    neighbours = (1..4).map { GameOfLife::Cell.new(state: GameOfLife::States.alive) } +
                 (1..4).map { GameOfLife::Cell.new(state: GameOfLife::States.dead) }
    dead_cell = GameOfLife::Cell.new(state: GameOfLife::States.dead)
    subsequent_cell = GameOfLife::Cell.subsequent_state(cell: dead_cell, neighbours: neighbours)

    subsequent_cell.dead?.must_equal true
  end
end

describe GameOfLife::Grid do
  before do
    @size = 15
    @random_grid = GameOfLife::Grid.new_random(size: @size).to_a
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
    new_grid = GameOfLife::Grid.new_from(grid: @random_grid) { |row, col| @random_grid[row][col] }
    new_grid.to_a.must_equal @random_grid
  end

  it 'should return a grid with values transformed when block is given' do
    grid_of_ones = Array.new(@size) { Array.new(@size, 1) }
    new_grid = GameOfLife::Grid.new_from(grid: @random_grid) { 1 }
    new_grid.to_a.must_equal grid_of_ones
  end

  it 'should give the grid coordinates of a cell when given that cell' do
    grid = GameOfLife::Grid.new_random(size: 3)
    cell = grid.to_a[0][0]
    grid.coordinates_of(cell).must_equal [0, 0]
  end
end

describe GameOfLife::Neighbours do
  it 'should return the expected number of neighbours' do
    grid = GameOfLife::Grid.new_random(size: 3)
    middle = [1, 1]
    neighbours = GameOfLife::Neighbours.new(coordinates: middle, grid: grid).to_a
    neighbours.count.must_equal 8
  end

  it 'should return the expected number of neighbours on a larger grid' do
    grid = GameOfLife::Grid.new_random(size: 4)
    middle = [1, 2]
    neighbours = GameOfLife::Neighbours.new(coordinates: middle, grid: grid).to_a
    neighbours.count.must_equal 8
  end

  it 'should return cell objects' do
    grid = GameOfLife::Grid.new_random(size: 4)
    middle = [1, 2]
    neighbours = GameOfLife::Neighbours.new(coordinates: middle, grid: grid).to_a
    neighbours[0].must_be_kind_of GameOfLife::Cell
  end

  it 'should wrap the coordinates if target cell is at the edge of the grid' do
    grid = GameOfLife::Grid.new_random(size: 4)
    middle = [3, 0]
    neighbours = GameOfLife::Neighbours.new(
      coordinates: middle, grid: grid
    ).coordinates_of_neighbours
    expected = [
      [2, 3], [2, 0], [2, 1], [3, 3], [3, 1], [0, 3], [0, 0], [0, 1]
    ]
    (neighbours - expected).must_be_empty
  end

  it 'should wrap the coordinates if the target cell is at the opposite end of the grid' do
    grid = GameOfLife::Grid.new_random(size: 4)
    middle = [0, 3]
    neighbours = GameOfLife::Neighbours.new(
      coordinates: middle, grid: grid
    ).coordinates_of_neighbours
    expected = [
      [3, 2], [0, 2], [1, 2], [3, 3], [1, 3], [3, 0], [0, 0], [1, 0]
    ]
    (neighbours - expected).must_be_empty
  end
end
