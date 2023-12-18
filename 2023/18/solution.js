'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

const CORNERS = {
  'U:L': '7', 'U:R': 'F',
  'R:U': 'J', 'R:D': '7',
  'D:L': 'J', 'D:R': 'L',
  'L:U': 'L', 'L:D': 'F'
}

const LINES = {
  'U': '|',
  'D': '|',
  'L': '-',
  'R': '-'
}

const MOVES = {
  L: ({ row, col }, n = 1) => ({ row, col: col - n }),
  R: ({ row, col }, n = 1) => ({ row, col: col + n }),
  U: ({ row, col }, n = 1) => ({ row: row - n, col }),
  D: ({ row, col }, n = 1) => ({ row: row + n, col })
}

function gridArea (insts) {
  let pos = { row: 0, col: 0, dir: insts[insts.length - 1].dir }
  let boundary = []

  for (let { dir, n } of insts ) {
    for (let i = 0; i < n; i++) {
      let chr = '.'

      if (i === 0) {
        chr = CORNERS[[pos.dir, dir].join(':')] || '.'
      } else {
        chr = LINES[dir]
      }
      boundary.push({ ...pos, chr })
      pos = { ...MOVES[dir](pos), dir }
    }
  }

  let rowMin = null
  let rowMax = null
  let colMin = null
  let colMax = null

  for (let { row, col } of boundary) {
    rowMin = (rowMin === null || row < rowMin) ? row : rowMin
    rowMax = (rowMax === null || row > rowMax) ? row : rowMax
    colMin = (colMin === null || col < colMin) ? col : colMin
    colMax = (colMax === null || col > colMax) ? col : colMax
  }

  let rows = 1 + rowMax - rowMin
  let cols = 1 + colMax - colMin
  let grid = []

  for (let row = 0; row < rows; row++) {
    grid.push(new Array(cols).fill('.'))
  }

  for (let item of boundary) {
    grid[item.row - rowMin][item.col - colMin] = item.chr
  }

  let area = boundary.length

  for (let [row, cells] of grid.entries()) {
    let edges = 0
    let breaker = null

    for (let [col, cell] of cells.entries()) {
      if (cell === '.') {
        if (edges % 2 === 1) area += 1
        continue
      }

      if (cell === 'F') {
        breaker = 'J'
      } else if (cell === 'L') {
        breaker = '7'
      } else if (cell === '|' || cell === breaker) {
        edges += 1
        breaker = null
      }
    }
  }

  return area
}

function polygonArea (insts) {
  let pos = { row: 0, col: 0 }
  let vertices = []
  let edge = 0
  let area = 0

  for (let { dir, n } of insts) {
    vertices.push(pos)
    edge += n
    pos = MOVES[dir](pos, n)
  }

  for (let [i, vertex] of vertices.entries()) {
    let { row: rowA, col: colA } = vertex
    let { row: rowB, col: colB } = vertices[i + 1] || vertices[0]

    area += rowA * colB - rowB * colA
  }
  return Math.abs(area) / 2 + edge / 2 + 1
}

let insts = lines.map((line) => {
  let [_, dir, n, hex] = line.match(/(L|U|R|D)\s+(\d+)\s+\(#(.+)\)/)
  n = parseInt(n, 10)
  return { dir, n, hex }
})

let area = gridArea(insts)
console.log({ area })

area = polygonArea(insts)
console.log({ area })

let directions = { '0': 'R', '1': 'D', '2': 'L', '3': 'U' }

insts = insts.map(({ hex }) => {
  let chrs = [...hex]
  let last = chrs.pop()

  return {
    dir: directions[last],
    n: parseInt(chrs.join(''), 16)
  }
})

area = polygonArea(insts)
console.log({ area })
