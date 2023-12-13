'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let grid = []
let grids = [grid]

for (let line of lines) {
  if (line === '') {
    grid = []
    grids.push(grid)
  } else {
    grid.push(line.split(''))
  }
}

function findReflections (grid, maxDiff = 0) {
  let reflections = []

  for (let row = 1; row < grid.length; row++) {
    let diffs = 0
    for (let col = 0; col < grid[0].length; col++) {
      for (let i = 0; i < row; i++) {
        let j = 2 * row - i - 1
        if (!grid[j]) continue
        if (grid[i][col] !== grid[j][col]) diffs += 1
      }
    }
    if (diffs === maxDiff) {
      reflections.push({ type: 'horizontal', offset: row })
    }
  }

  for (let col = 1; col < grid[0].length; col++) {
    let diffs = 0
    for (let row = 0; row < grid.length; row++) {
      for (let i = 0; i < col; i++) {
        let j = 2 * col - i - 1
        if (!grid[row][j]) continue
        if (grid[row][i] !== grid[row][j]) diffs += 1
      }
    }
    if (diffs === maxDiff) {
      reflections.push({ type: 'vertical', offset: col })
    }
  }

  return reflections
}

function summary (reflections) {
  return reflections.reduce((acc, { type, offset }) => {
    if (type === 'vertical') {
      return acc + offset
    } else if (type === 'horizontal') {
      return acc + 100 * offset
    }
  }, 0)
}

let reflections = grids.flatMap((grid) => findReflections(grid, 0))
let sum = summary(reflections)
console.log({ sum })

reflections = grids.flatMap((grid) => findReflections(grid, 1))
sum = summary(reflections)
console.log({ sum })
