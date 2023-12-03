'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let grid = lines.map((line) => [...line])
let numbers = []

for (let [row, line] of grid.entries()) {
  let number = null
  for (let [col, chr] of line.entries()) {
    if (/\d/.test(chr)) {
      number ||= { row, col, text: '' }
      number.text += chr
    } else if (number) {
      number.value = parseInt(number.text, 10)
      numbers.push(number)
      number = null
    }
  }
  if (number) {
    number.value = parseInt(number.text, 10)
    numbers.push(number)
  }
}

const SYMBOL = /[^0-9.]/

function isSymbol (grid, row, col) {
  if (!grid[row]) return false
  let chr = grid[row][col]
  return chr && SYMBOL.test(chr)
}

let parts = numbers.filter((number) => {
  let { row } = number
  let a = number.col - 1
  let b = number.col + number.text.length

  if (isSymbol(grid, row, a) || isSymbol(grid, row, b)) {
    return true
  }

  for (let col = a; col <= b; col++) {
    if (isSymbol(grid, row - 1, col) || isSymbol(grid, row + 1, col)) {
      return true
    }
  }

  return false
})

let sum = parts.map((part) => part.value).reduce((a, b) => a + b)
console.log({ sum })
