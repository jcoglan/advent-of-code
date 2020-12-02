const fs = require('fs')
const path = require('path')

function parseLine(line) {
  let match = line.match(/(\d+)-(\d+) +([a-z]): +(.*)/)

  return [
    parseInt(match[1]),
    parseInt(match[2]),
    match[3],
    match[4]
  ]
}

function oldPolicy([min, max, chr, password]) {
  let count = [...password].filter((c) => c === chr).length
  return count >= min && count <= max
}

function newPolicy([min, max, chr, password]) {
  return (password.charAt(min - 1) === chr)
       ^ (password.charAt(max - 1) === chr)
}

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/).filter((s) => s !== '').map(parseLine)

console.log(lines.filter(oldPolicy).length)
console.log(lines.filter(newPolicy).length)
