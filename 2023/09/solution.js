'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let histories = lines.map((line) => {
  return line.split(/\s+/).map((n) => parseInt(n, 10))
})

let stacks = histories.map((hist) => {
  let stack = [hist.slice()]

  while (true) {
    let last = stack[stack.length - 1]
    let next = []
    let diff = 0

    for (let i = 0; i < last.length - 1; i++) {
      let d = last[i + 1] - last[i]
      next.push(d)
      diff = (d !== 0) ? d : diff
    }

    if (diff === 0) return stack
    stack.push(next)
  }
})

let nextValues = stacks.map((stack) => {
  let n = 0

  for (let i = stack.length - 1; i >= 0; i--) {
    let row = stack[i]
    n = row[row.length - 1] + n
  }
  return n
})

let sum = nextValues.reduce((a, b) => a + b)
console.log({ sum })

let prevValues = stacks.map((stack) => {
  let n = 0

  for (let i = stack.length - 1; i >= 0; i--) {
    n = stack[i][0] - n
  }
  return n
})

sum = prevValues.reduce((a, b) => a + b)
console.log({ sum })
