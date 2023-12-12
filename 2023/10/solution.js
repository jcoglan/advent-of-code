'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

const CHAINS = {
  N: { '7': 'W', '|': 'N', 'F': 'E' },
  E: { 'J': 'N', '-': 'E', '7': 'S' },
  S: { 'L': 'E', '|': 'S', 'J': 'W' },
  W: { 'F': 'S', '-': 'W', 'L': 'N' }
}

const MOVES = {
  N: ([row, col]) => [row - 1, col],
  E: ([row, col]) => [row, col + 1],
  S: ([row, col]) => [row + 1, col],
  W: ([row, col]) => [row, col - 1]
}

const INVERSE = { N: 'S', E: 'W', S: 'N', W: 'E' }

function getCell (grid, [row, col]) {
  if (row < 0 || row >= grid.length) return null

  let cells = grid[row]
  if (col < 0 || col >= cells.length) return null

  return cells[col]
}

class Walker {
  constructor (grid, pos, dir) {
    this.grid = grid
    this.pos = pos
    this.dir = dir
    this.distance = 0
  }

  step () {
    this.pos = MOVES[this.dir](this.pos)
    let cell = getCell(this.grid, this.pos)
    this.dir = CHAINS[this.dir][cell]
    this.distance += 1
  }

  isAt ([row, col]) {
    return this.pos[0] === row && this.pos[1] === col
  }
}

let grid = lines.map((line) => line.split(''))
let start = null

for (let row = 0; row < grid.length; row++) {
  for (let col = 0; col < grid[row].length; col++) {
    if (grid[row][col] === 'S') start = [row, col]
  }
}

let directions = ['N', 'E', 'S', 'W'].filter((dir) => {
  let pos = MOVES[dir](start)
  let cell = getCell(grid, pos)
  return Object.keys(CHAINS[dir]).includes(cell)
})

let [a, b] = directions.map((dir) => new Walker(grid, start, dir))

while (true) {
  a.step()
  if (a.isAt(b.pos)) break
  b.step()
  if (a.isAt(b.pos)) break
}

console.log(a.distance)

let walker = new Walker(grid, start, directions[0])
let inPath = new Set()

while (walker.distance === 0 || !walker.isAt(start)) {
  inPath.add(walker.pos.join(','))
  walker.step()
}

let area = 0

for (let [row, cells] of grid.entries()) {
  let edges = 0
  let breaker = null

  for (let [col, cell] of cells.entries()) {
    if (!inPath.has([row, col].join(','))) {
      if (edges % 2 === 1) area += 1
      continue
    }

    if (cell === 'S') {
      let [a, b] = [INVERSE[directions[1]], directions[0]]
      cell = Object.entries(CHAINS[a]).find(([k, v]) => v === b)[0]
    }

    if (cell === 'F') {
      breaker = 'J'
    } else if (cell === 'L') {
      breaker = '7'
    } else if (cell === '|' || cell === breaker) {
      edges += 1
      breaker = null
    }
  }
}

console.log({ area })
