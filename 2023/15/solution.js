'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')

function hash (str) {
  let hash = 0

  for (let i = 0; i < str.length; i++) {
    hash = ((hash + str.charCodeAt(i)) * 17) % 256
  }
  return hash
}

let hashes = input.split(',').map(hash)
let sum = hashes.reduce((a, b) => a + b)
console.log({ sum })

let boxes = new Array(256)

for (let step of input.split(',')) {
  let [_, label, op, f] = step.match(/([a-z]+)(-|=)([0-9]*)/)

  let idx = hash(label)
  boxes[idx] ||= []
  let box = boxes[idx]

  idx = box.findIndex((lens) => lens.label === label)

  if (op === '-') {
    if (idx >= 0) box.splice(idx, 1)
  }
  if (op === '=') {
    f = parseInt(f, 10)
    if (idx >= 0) {
      box[idx].f = f
    } else {
      box.push({ label, f })
    }
  }
}

let power = 0

for (let [i, box] of boxes.entries()) {
  if (!box) continue

  for (let [j, lens] of box.entries()) {
    power += (i + 1) * (j + 1) * lens.f
  }
}

console.log({ power })
