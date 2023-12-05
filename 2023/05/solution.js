'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

let seeds = []
let maps = {}, map

for (let line of lines) {
  let match

  if (match = line.match(/^seeds:/)) {
    let ids = line.split(':')[1].match(/\d+/g)
    seeds = ids.map((id) => parseInt(id, 10))
  } else if (match = line.match(/^([a-z]+)-to-([a-z]+) map:/)) {
    map = []
    maps[match[1]] ||= {}
    maps[match[1]][match[2]] = map
  } else if (match = line.match(/\d+/g)) {
    if (match.length === 3) {
      map.push({
        source: parseInt(match[1], 10),
        target: parseInt(match[0], 10),
        size: parseInt(match[2], 10)
      })
    }
  }
}

for (let outer of Object.values(maps)) {
  for (let inner of Object.values(outer)) {
    inner.sort((a, b) => a.source - b.source)
  }
}

function resolve ([type, range]) {
  let targets = maps[type]
  if (!targets) return [[type, range]]

  return Object.entries(targets).flatMap(([key, entries]) => {
    let translated = translate(entries, range)

    return translated.flatMap((range) => {
      return resolve([key, range])
    })
  })
}

function translate (entries, range) {
  let outputs = []
  let watermark = range.start

  for (let entry of entries) {
    let slice = intersection(entry, range)
    if (!slice) continue

    if (slice.source > watermark) {
      outputs.push({ start: watermark, size: slice.source - watermark })
    }

    outputs.push({ start: slice.target, size: slice.size })
    watermark = slice.source + slice.size
  }

  let expectedEnd = range.start + range.size

  if (watermark < expectedEnd) {
    outputs.push({ start: watermark, size: expectedEnd - watermark })
  }

  return outputs
}

function intersection (entry, range) {
  let start = Math.max(entry.source, range.start)
  let end = Math.min(entry.source + entry.size, range.start + range.size)

  if (start >= end) return null

  return {
    source: start,
    target: entry.target + start - entry.source,
    size: end - start
  }
}

function merge (ranges) {
  ranges.sort((a, b) => a.start - b.start)
  let merged = [], last = null

  for (let range of ranges) {
    if (last && last.start + last.size === range.start) {
      last.size += range.size
    } else {
      merged.push(range)
      last = range
    }
  }
  return merged
}

function seedsToLocations (seedRanges) {
  let locations = seedRanges
      .flatMap((range) => resolve(['seed', range]))
      .map(([, loc]) => loc)

  return merge(locations)
}

let seedRanges = seeds.map((start) => ({ start, size: 1 }))
seedRanges.sort((a, b) => a.start - b.start)

let locations = seedsToLocations(seedRanges)
console.log(locations[0])

seedRanges = []
for (let i = 0; i < seeds.length; i += 2) {
  seedRanges.push({ start: seeds[i], size: seeds[i + 1] })
}
seedRanges.sort((a, b) => a.start - b.start)

locations = seedsToLocations(seedRanges)
console.log(locations[0])
