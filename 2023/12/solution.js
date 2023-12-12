'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

function parse (line) {
  let [cells, counts] = line.split(/\s+/)

  cells = [...cells.split(''), '.']
  cells = { vals: cells, idx: 0, seen: 0 }

  counts = counts.split(',').map((n) => parseInt(n, 10))
  counts = { vals: counts, idx: 0 }

  return forward({ cells, counts })
}

function combinations (state, cache = new Map()) {
  if (complete(state)) return 1

  let { cells, counts } = state
  let key = [cells.idx, cells.seen, counts.idx].join(':')
  if (cache.has(key)) return cache.get(key)

  let count = extend(state)
      .map((s) => combinations(s, cache))
      .reduce((a, b) => a + b, 0)

  cache.set(key, count)
  return count
}

function complete ({ cells, counts }) {
  return cells.idx === cells.vals.length &&
      counts.idx === counts.vals.length
}

function extend (state) {
  return ['.', '#']
      .map((type) => fill(state, type))
      .filter((state) => state !== null)
}

function fill (state, type) {
  let cells = state.cells.vals.slice()
  cells[state.cells.idx] = type

  return forward({
    cells: { ...state.cells, vals: cells },
    counts: { ...state.counts }
  })
}

function forward (state) {
  let { cells, counts } = state

  while (cells.idx < cells.vals.length && cells.vals[cells.idx] !== '?') {
    let type = cells.vals[cells.idx]
    let expected = counts.vals[counts.idx]

    if (type === '#') {
      cells.seen += 1
      if (cells.seen > expected) {
        return null
      }
    }

    if (type === '.' && cells.seen > 0) {
      if (cells.seen === expected) {
        cells.seen = 0
        counts.idx += 1
      } else {
        return null
      }
    }

    cells.idx += 1
  }

  if (cells.idx === cells.vals.length && counts.idx < counts.vals.length) {
    return null
  } else {
    return state
  }
}

let rows = lines.map(parse)
let count = rows.reduce((a, state) => a + combinations(state), 0)
console.log({ count })

let unfolded = rows.map(({ cells, counts }) => {
  let newCells = []
  let newCounts = []

  let end = cells.vals.pop()

  for (let i = 0; i < 5; i++) {
    newCells = [...newCells, ...cells.vals, '?']
    newCounts = [...newCounts, ...counts.vals]
  }

  newCells[newCells.length - 1] = end

  return {
    cells: { ...cells, vals: newCells },
    counts: { ...counts, vals: newCounts }
  }
})

count = unfolded.reduce((a, state) => a + combinations(state), 0)
console.log({ count })
