'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

const SYMBOL = /[^0-9.]/

let grid = lines.map((line) => [...line])
let numbers = []
let symbols = new Map()
let parts = []

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
    if (SYMBOL.test(chr)) {
      symbols.set([row, col].join(':'), { chr, neighbours: [] })
    }
  }
  if (number) {
    number.value = parseInt(number.text, 10)
    numbers.push(number)
  }
}

function checkNeighbour (row, col, number) {
  let symbol = symbols.get([row, col].join(':'))
  if (symbol) {
    parts.push(number)
    symbol.neighbours.push(number)
  }
}

for (let number of numbers) {
  let { row } = number
  let a = number.col - 1
  let b = number.col + number.text.length

  checkNeighbour(row, a, number)
  checkNeighbour(row, b, number)

  for (let col = a; col <= b; col++) {
    checkNeighbour(row - 1, col, number)
    checkNeighbour(row + 1, col, number)
  }
}

let sum = parts.map((part) => part.value).reduce((a, b) => a + b)
console.log({ sum })

let gears = [...symbols.values()].filter((symbol) => {
  return symbol.chr === '*' && symbol.neighbours.length === 2
})

let ratios = gears.map((gear) => {
  let [a, b] = gear.neighbours
  return a.value * b.value
})

sum = ratios.reduce((a, b) => a + b)
console.log({ sum })
