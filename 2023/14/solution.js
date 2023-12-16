'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

function tilt (grid) {
  for (let col = 0; col < grid[0].length; col++) {
    let spans = getSpans(grid, col)

    for (let row = 0; row < grid.length; row++) {
      if (grid[row][col] !== '#') grid[row][col] = '.'
    }
    for (let { offset, count } of spans) {
      for (let row = offset; row < offset + count; row++) {
        grid[row][col] = 'O'
      }
    }
  }
}

function getSpans (grid, col) {
  let current = { offset: 0, count: 0 }
  let spans = [current]

  for (let row = 0; row < grid.length; row++) {
    let type = grid[row][col]

    if (type === '#') {
      current = { offset: row + 1, count: 0 }
      spans.push(current)
    }

    if (type === 'O') {
      current.count += 1
    }
  }
  return spans
}

function rotate (grid) {
  let newGrid = []

  for (let col = 0; col < grid[0].length; col++) {
    let newRow = []
    newGrid.push(newRow)

    for (let row = grid.length - 1; row >= 0; row--) {
      newRow.push(grid[row][col])
    }
  }
  return newGrid
}

function getLoad (grid) {
  let load = 0

  for (let row = 0; row < grid.length; row++) {
    for (let col = 0; col < grid[row].length; col++) {
      if (grid[row][col] === 'O') {
        load += grid.length - row
      }
    }
  }
  return load
}

let grid = lines.map((line) => line.split(''))
tilt(grid)
console.log({ load: getLoad(grid) })

grid = lines.map((line) => line.split(''))
let states = new Map()
let loop = null

for (let cycle = 0; cycle < 1000; cycle++) {
  let key = grid.map((row) => row.join('')).join(':')
  if (states.has(key)) {
    loop = { start: states.get(key), end: cycle }
    break
  }
  states.set(key, cycle)
  for (let i = 0; i < 4; i++) {
    tilt(grid)
    grid = rotate(grid)
  }
}

let n = loop.start + (1000000000 - loop.start) % (loop.end - loop.start)

for (let [key, val] of states) {
  if (val === n) {
    grid = key.split(':').map((line) => line.split(''))
    console.log({ load: getLoad(grid) })
  }
}
