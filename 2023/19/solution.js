'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

const START = 'in'
const ACCEPT = 'A'
const REJECT = 'R'

const OPS = {
  '<': (a, b) => a < b,
  '>': (a, b) => a > b
}

let workflows = new Map()
let parts = []

for (let line of lines) {
  let match = null

  if (match = line.match(/^([a-z]+)\{(.+?)\}$/i)) {
    let [_, name, rules] = match

    rules = rules.split(',').map((rule) => {
      let [condition, target] = rule.split(':')
      if (target) {
        let [_, category, op, value] = condition.match(/([a-z]+)(<|>)(\d+)/i)
        return {
          condition: { category, op, value: parseInt(value, 10) },
          target
        }
      } else {
        return { condition: null, target: condition }
      }
    })

    workflows.set(name, { name, rules })
  }

  if (match = line.match(/^\{(.*?)\}$/)) {
    let [_, props] = match
    props = props.split(',').map((pair) => {
      let [key, value] = pair.split('=')
      value = parseInt(value, 10)
      return [key, value]
    })
    parts.push(Object.fromEntries(props))
  }
}

let accepted = parts.filter((part) => {
  let state = START

  while (state !== ACCEPT && state !== REJECT) {
    let flow = workflows.get(state)
    for (let { condition, target } of flow.rules) {
      if (!condition) {
        state = target
        break
      }
      let value = part[condition.category]
      if (value !== undefined && OPS[condition.op](value, condition.value)) {
        state = target
        break
      }
    }
  }

  return state === ACCEPT
})

let sum = accepted.reduce((acc, part) => {
  return acc + Object.values(part).reduce((a, b) => a + b)
}, 0)

console.log({ sum })

let chains = [
  [{ state: ACCEPT }]
]

function anyIncomplete (chains) {
  return chains.some(([first]) => first.state !== START)
}

function matchPrefixes (state, { name, rules }) {
  let failed = []
  let prefixes = []

  for (let { condition, target } of rules) {
    if (target === state) {
      prefixes.push({ state: name, failed: failed.slice(), condition })
    }
    failed.push(condition)
  }
  return prefixes
}

while (anyIncomplete(chains)) {
  chains = chains.flatMap((chain) => {
    let [{ state }] = chain
    if (state === START) return [chain]

    let prefixes = [...workflows.values()].flatMap((flow) => {
      return matchPrefixes(state, flow)
    })

    return prefixes.map((prefix) => [prefix, ...chain])
  })
}

const VAL_MIN = 1
const VAL_MAX = 4000

function restrict (constraint, { category, op, value }, add = 0) {
  if ((add === 0 && op === '<') || (add === 1 && op === '>')) {
    constraint[category].min = value + add
  } else {
    constraint[category].max = value - add
  }
}

let acceptable = chains.map((chain) => {
  let constraint = {
    x: { min: VAL_MIN, max: VAL_MAX },
    m: { min: VAL_MIN, max: VAL_MAX },
    a: { min: VAL_MIN, max: VAL_MAX },
    s: { min: VAL_MIN, max: VAL_MAX }
  }

  for (let { failed = [], condition } of chain) {
    for (let condition of failed) {
      restrict(constraint, condition, 0)
    }
    if (condition) {
      restrict(constraint, condition, 1)
    }
  }

  return constraint
})

let combinations = acceptable.reduce((sum, constraint) => {
  return sum + Object.values(constraint).reduce((prod, range) => {
    return prod * (1 + range.max - range.min)
  }, 1)
}, 0)

console.log({ combinations })
