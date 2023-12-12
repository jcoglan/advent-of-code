'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let steps = null
let map = new Map()

for (let line of lines) {
  let match
  if (match = line.match(/^[LR]+$/)) {
    steps = line.split('')
  } else if (match = line.match(/([A-Z]+)\s*=\s*\(([A-Z]+)\s*,\s*([A-Z]+)\)/)) {
    map.set(match[1], [match[2], match[3]])
  }
}

class Walker {
  constructor (steps, map, pos) {
    this.steps = steps
    this.map = map
    this.pos = pos
    this.distance = 0
  }

  step () {
    let step = this.steps[this.distance % this.steps.length]
    this.pos = this.map.get(this.pos)[step === 'L' ? 0 : 1]
    this.distance += 1
  }
}

let me = new Walker(steps, map, 'AAA')
while (me.pos !== 'ZZZ') me.step()
console.log(me.distance)

let starts = [...map.keys()].filter((pos) => pos.endsWith('A'))

let distances = starts.map((pos) => {
  let ghost = new Walker(steps, map, pos)
  while (!ghost.pos.endsWith('Z')) ghost.step()
  return ghost.distance
})

function gcd (a, b) {
  if (b === 0) {
    return a
  } else {
    return gcd(b, a % b)
  }
}

function lcm (a, b) {
  return a * b / gcd(a, b)
}

let distance = distances.reduce((a, b) => lcm(a, b))
console.log(distance)
