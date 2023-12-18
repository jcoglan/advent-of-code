'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

const MOVES = {
  L: ({ row, col }) => ({ row, col: col - 1 }),
  R: ({ row, col }) => ({ row, col: col + 1 }),
  U: ({ row, col }) => ({ row: row - 1, col }),
  D: ({ row, col }) => ({ row: row + 1, col })
}

const OPPOSITES = { L: 'R', R: 'L', U: 'D', D: 'U' }

function takeShortest (states) {
  let min = null
  let index = null

  for (let [i, state] of states.entries()) {
    if (min === null || state.loss < min) {
      min = state.loss
      index = i
    }
  }

  let [shortest] = states.splice(index, 1)
  return shortest
}

function shortestPath (grid, limits) {
  let states = [
    { pos: { row: 0, col: 0 }, steps: 0, loss: 0 }
  ]

  let [endRow, endCol] = [grid.length - 1, grid[0].length - 1]

  let minimums = new Map()
  limits.min ||= 0

  while (states.length > 0) {
    let state = takeShortest(states)
    let { pos: { row, col } } = state

    if (row === endRow && col === endCol && state.steps >= limits.min) {
      return state
    }

    for (let dir of ['R', 'D', 'L', 'U']) {
      if (state.dir) {
        if (dir === OPPOSITES[state.dir]) continue
        if (state.steps < limits.min && dir !== state.dir) continue
      }

      let steps = (dir === state.dir) ? state.steps + 1 : 1
      if (steps > limits.max) continue

      let pos = MOVES[dir](state.pos)
      if (grid[pos.row] === undefined) continue
      if (grid[pos.row][pos.col] === undefined) continue

      let loss = state.loss + grid[pos.row][pos.col]
      let key = [pos.row, pos.col, dir, steps].join(':')
      let min = minimums.get(key)

      if (min === undefined || loss < min) {
        minimums.set(key, loss)
        states.push({ pos, dir, steps, loss })
      }
    }
  }
}

let grid = lines.map((line) => line.split('').map((n) => parseInt(n, 10)))

let state = shortestPath(grid, { max: 3 })
console.log({ state })

state = shortestPath(grid, { min: 4, max: 10 })
console.log({ state })
