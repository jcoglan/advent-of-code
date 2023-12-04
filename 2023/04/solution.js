'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let cards = lines.map((line) => {
  let [_, winners, samples] = line.split(/:|\|/)

  winners = new Set(winners.match(/\d+/g).map((n) => parseInt(n, 10)))
  samples = new Set(samples.match(/\d+/g).map((n) => parseInt(n, 10)))

  return { winners, samples, copies: 1 }
})

let points = 0

for (let [i, { winners, samples, copies }] of cards.entries()) {
  let matches = [...samples].filter((n) => winners.has(n)).length
  points += (matches > 0) ? Math.pow(2, matches - 1) : 0

  for (let j = 0; j < matches; j++) {
    cards[i + 1 + j].copies += copies
  }
}

console.log({ points })

let count = cards.map((c) => c.copies).reduce((a, b) => a + b)
console.log({ count })
