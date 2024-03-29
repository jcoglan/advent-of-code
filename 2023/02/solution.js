'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let games = lines.map((line) => {
  let [id, samples] = line.split(/\s*:\s*/)
  id = parseInt(id.match(/\d+/)[0], 10)

  samples = samples.split(/\s*;\s*/).map((sample) => {
    let colors = sample.split(/\s*,\s*/).map((color) => {
      let [_, count, type] = color.match(/(\d+) (red|green|blue)/)
      return [type, parseInt(count, 10)]
    })
    return Object.fromEntries(colors)
  })

  return { id, samples }
})

let possibleGames = games.filter((game) => {
  return game.samples.every((sample) => {
    return (sample.red || 0) <= 12
        && (sample.green || 0) <= 13
        && (sample.blue || 0) <= 14
  })
})

let sum = possibleGames.map((game) => game.id).reduce((a, b) => a + b)
console.log({ sum })

let minimumSets = games.map((game) => {
  let red = 0, green = 0, blue = 0

  for (let sample of game.samples) {
    red = Math.max(red, sample.red || 0)
    green = Math.max(green, sample.green || 0)
    blue = Math.max(blue, sample.blue || 0)
  }
  return { red, green, blue }
})

let powers = minimumSets.map((set) => {
  return set.red * set.green * set.blue
})
sum = powers.reduce((a, b) => a + b)
console.log({ sum })
