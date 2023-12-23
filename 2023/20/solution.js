'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

const LO = 1
const HI = 2

const FLIP = '%'
const CONJ = '&'
const BCAST = 'broadcaster'

function createModules (lines) {
  let modules = new Map()

  for (let line of lines) {
    let [_, type, name, targets] = line.match(/^(%|&)?([a-z]+)\s*->\s*(.*)$/i)
    targets = targets.split(/\s*,\s*/)
    modules.set(name, { name, type, targets })
  }

  for (let module of modules.values()) {
    for (let target of module.targets) {
      let tgt = modules.get(target)
      if (tgt?.type !== CONJ) continue

      tgt.state ||= new Map()
      tgt.state.set(module.name, LO)
    }
  }

  return modules
}

function emit (pulses, module, value) {
  for (let target of module.targets) {
    let n = pulses.count.get(value) 
    pulses.count.set(value, n + 1)

    pulses.queue.push({ source: module.name, target, value })
  }
}

function handle (pulses, modules) {
  let pulse = pulses.queue.shift()

  let module = modules.get(pulse.target)
  if (!module) return

  if (module.name === BCAST) {
    emit(pulses, module, pulse.value)
  }

  if (module.type === FLIP) {
    if (pulse.value === LO) {
      module.on ||= false
      emit(pulses, module, module.on ? LO : HI)
      module.on = !module.on
    }
  }

  if (module.type === CONJ) {
    module.state.set(pulse.source, pulse.value)
    if ([...module.state.values()].every((value) => value === HI)) {
      emit(pulses, module, LO)
    } else {
      emit(pulses, module, HI)
    }
  }
}

function run (lines, limit, halt = () => false) {
  let modules = createModules(lines)
  let pulses = { count: new Map([[LO, 0], [HI, 0]]), queue: [] }

  for (let n = 1; n <= limit; n++) {
    let halted = false
    emit(pulses, { name: 'button', targets: [BCAST] }, LO)

    while (pulses.queue.length > 0) {
      let [pulse] = pulses.queue
      if (halt(pulse)) halted = true
      handle(pulses, modules)
    }
    if (halted) return { n }
  }

  return { pulses }
}

let { pulses } = run(lines, 1000)
let product = pulses.count.get(LO) * pulses.count.get(HI)
console.log({ product })

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

let modules = createModules(lines)

let cycles = [...modules.values()]
    .filter((module) => module.targets.includes('qn'))
    .map((module) => (p) => p.source === module.name && p.value === HI)
    .map((cycle) => run(lines, 2**32, cycle).n)

product = cycles.reduce(lcm)
console.log({ product })
