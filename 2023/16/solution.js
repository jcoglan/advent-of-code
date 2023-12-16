'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

const MOVES = {
  L: ({ row, col }) => ({ row, col: col - 1 }),
  R: ({ row, col }) => ({ row, col: col + 1 }),
  U: ({ row, col }) => ({ row: row - 1, col }),
  D: ({ row, col }) => ({ row: row + 1, col })
}

const TURNS = {
  '/':  { L: 'D', R: 'U', U: 'R', D: 'L' },
  '\\': { L: 'U', R: 'D', U: 'L', D: 'R' }
}

const SPLITS = {
  '|': { ins: ['L', 'R'], outs: ['U', 'D'] },
  '-': { ins: ['U', 'D'], outs: ['L', 'R'] }
}

const GRID = lines.map((line) => line.split(''))

function move ({ pos, dir }) {
  return { pos: MOVES[dir](pos), dir }
}

function energized (beam) {
  let beams = [beam]
  let visited = new Set()

  while (beams.length > 0) {
    beams = beams.filter((beam) => {
      if (beam.pos.row < 0 || beam.pos.row >= GRID.length) {
        return false
      }
      if (beam.pos.col < 0 || beam.pos.col >= GRID[0].length) {
        return false
      }
      let key = JSON.stringify(beam)
      if (visited.has(key)) {
        return false
      } else {
        visited.add(key)
        return true
      }
    })

    beams = beams.flatMap(({ pos, dir }) => {
      let cell = GRID[pos.row][pos.col]

      if (cell === '.') {
        return [move({ pos, dir })]
      }
      if (cell in TURNS) {
        dir = TURNS[cell][dir]
        return [move({ pos, dir })]
      }
      if (cell in SPLITS) {
        if (SPLITS[cell].ins.includes(dir)) {
          return SPLITS[cell].outs.map((dir) => {
            return move({ pos, dir })
          })
        } else {
          return [move({ pos, dir })]
        }
      }
    })
  }

  let energized = [...visited].map((key) => JSON.parse(key).pos)
  let unique = new Set(energized.map((pos) => JSON.stringify(pos)))

  return unique.size
}

let energy = energized({ pos: { row: 0, col: 0 }, dir: 'R' })
console.log({ energy })

let results = []

for (let row = 0; row < GRID.length; row++) {
  let beam = { pos: { row, col: 0 }, dir: 'R' }
  results.push({ beam, energy: energized(beam) })

  beam = { pos: { row, col: GRID[0].length - 1 }, dir: 'L' }
  results.push({ beam, energy: energized(beam) })
}

for (let col = 0; col < GRID[0].length; col++) {
  let beam = { pos: { row: 0, col }, dir: 'D' }
  results.push({ beam, energy: energized(beam) })

  beam = { pos: { row: GRID.length - 1, col }, dir: 'U' }
  results.push({ beam, energy: energized(beam) })
}

results.sort((a, b) => b.energy - a.energy)
console.log(results[0])
