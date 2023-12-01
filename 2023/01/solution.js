'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let numbers = lines.map((line) => {
  let digits = line.match(/\d/g)
  let first = digits[0]
  let last = digits[digits.length - 1]
  return parseInt(first + last, 10)
})

let sum = numbers.reduce((a, b) => a + b)
console.log({ sum })
