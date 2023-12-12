'use strict'

const fs = require('fs')
const path = require('path')

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')
let lines = input.split(/\n/)

const RANKS = Object.fromEntries(
  '23456789TJQKA'.split('').map((rank, i) => [rank, i + 2])
)

const TYPES = {
  HIGH_CARD: 1,
  ONE_PAIR: 2,
  TWO_PAIR: 3,
  THREE_OF_A_KIND: 4,
  FULL_HOUSE: 5,
  FOUR_OF_A_KIND: 6,
  FIVE_OF_A_KIND: 7
}

function getCounts (cards) {
  let counts = {}

  for (let card of cards) {
    counts[card] ||= 0
    counts[card] += 1
  }
  return counts
}

function getType (cards) {
  let counts = getCounts(cards)
  let signature = Object.values(counts).sort().join(':')

  switch (signature) {
    case '5': return 'FIVE_OF_A_KIND'
    case '1:4': return 'FOUR_OF_A_KIND'
    case '2:3': return 'FULL_HOUSE'
    case '1:1:3': return 'THREE_OF_A_KIND'
    case '1:2:2': return 'TWO_PAIR'
    case '1:1:1:2': return 'ONE_PAIR'
    case '1:1:1:1:1': return 'HIGH_CARD'
  }
}

let hands = lines.map((line) => {
  let [cards, bid] = line.split(/\s+/)
  cards = cards.split('')
  bid = parseInt(bid, 10)

  return { cards, bid, type: getType(cards) }
})

function sortHands (hands) {
  return hands.sort((a, b) => {
    if (a.type !== b.type) {
      return TYPES[a.type] - TYPES[b.type]
    }
    for (let [i, card] of a.cards.entries()) {
      let aRank = RANKS[card]
      let bRank = RANKS[b.cards[i]]
      if (aRank !== bRank) {
        return aRank - bRank
      }
    }
    return 0
  })
}

function getWinnings (hands) {
  hands = sortHands(hands)
  let points = hands.map((hand, i) => hand.bid * (i + 1))
  return points.reduce((a, b) => a + b)
}

console.log(getWinnings(hands))


function jokerfy (cards) {
  let counts = getCounts(cards)
  if (!counts.J) return getType(cards)

  let others = Object.entries(counts).filter(([type]) => type !== 'J')
  let signature = others.map(([, n]) => n).sort()

  switch (signature.length) {
    case 0:
    case 1:
      return 'FIVE_OF_A_KIND'
    case 2:
      return (signature[0] === 1) ? 'FOUR_OF_A_KIND' : 'FULL_HOUSE'
    case 3:
      return 'THREE_OF_A_KIND'
    case 4:
      return 'ONE_PAIR'
  }
}

for (let hand of hands) {
  hand.type = jokerfy(hand.cards)
}
RANKS.J = 1

console.log(getWinnings(hands))
