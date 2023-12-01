'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

function capture (lines, lpat, rpat = lpat, translate = (x) => x) {
  return lines.map((line) => {
    let first = line.match(lpat)[0]
    let last = reverse(reverse(line).match(rpat)[0])
    return parseInt(translate(first) + translate(last), 10)
  })
}

function reverse (str) {
  return [...str].reverse().join('')
}

let numbers = capture(lines, /\d/)
let sum = numbers.reduce((a, b) => a + b)
console.log({ sum })

let lpat = /\d|one|two|three|four|five|six|seven|eight|nine/
let rpat = /\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/

numbers = capture(lines, lpat, rpat, (str) => {
  switch (str) {
    case 'one':   return '1'
    case 'two':   return '2'
    case 'three': return '3'
    case 'four':  return '4'
    case 'five':  return '5'
    case 'six':   return '6'
    case 'seven': return '7'
    case 'eight': return '8'
    case 'nine':  return '9'
    default:      return str
  }
})
sum = numbers.reduce((a, b) => a + b)
console.log({ sum })
