# Game of Life

This is my attempt at modelling [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) in OO Ruby.

The Game of Life models the life and death cycles of a population of cells on a two-dimensional grid.

You can run a simulation in the terminal:

```bash
> bundle exec game_of_life_viewer.rb
```

## The Rules

The Game of Life follows a set of simple rules.

1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
2. Any live cell with two or three live neighbours lives on to the next generation.
3. Any live cell with more than three live neighbours dies, as if by overpopulation.
4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

## The model

The grid can be of any given size. A cell, either dead or alive, is placed at each position on the grid.

Although the 'game' takes place on a grid, each cell should not be aware of the grid as a whole.

The grid is refreshed on each 'tick' of the clock. A cell's state is decided on each tick.

The grid is infinite. That is, the end of a row wraps to the beginning of the same row. The end of a column wraps to the start of the same column.
