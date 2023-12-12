'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let grid = lines.map((line) => {
  return line.split('').map((cell) => {
    let type = (cell === '#') ? 'galaxy' : 'space'
    return { type, width: 1, height: 1 }
  })
})

function expand (grid, factor) {
  for (let row of grid) {
    if (row.every((cell) => cell.type === 'space')) {
      for (let cell of row) {
        cell.height = factor
      }
    }
  }

  for (let i = 0; i < grid[0].length; i++) {
    if (grid.every((row) => row[i].type === 'space')) {
      for (let row of grid) {
        row[i].width = factor
      }
    }
  }
}

let galaxies = []

for (let [row, cells] of grid.entries()) {
  for (let [col, cell] of cells.entries()) {
    if (cell.type === 'galaxy') {
      galaxies.push({ row, col })
    }
  }
}

function getDistance (grid, galaxies, factor) {
  expand(grid, factor)
  let distance = 0

  for (let [i, galaxy] of galaxies.entries()) {
    for (let j = i + 1; j < galaxies.length; j++) {
      let other = galaxies[j]

      let [rowMin, rowMax] = [galaxy.row, other.row].sort((a, b) => a - b)
      let [colMin, colMax] = [galaxy.col, other.col].sort((a, b) => a - b)

      for (let i = rowMin; i < rowMax; i++) {
        distance += grid[i][colMin].height
      }
      for (let i = colMin; i < colMax; i++) {
        distance += grid[rowMax][i].width
      }
    }
  }
  return distance
}

console.log(getDistance(grid, galaxies, 2))
console.log(getDistance(grid, galaxies, 10))
console.log(getDistance(grid, galaxies, 100))
console.log(getDistance(grid, galaxies, 1000000))
