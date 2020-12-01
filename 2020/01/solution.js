const fs = require('fs')
const path = require('path')

function pairWithSum(numbers, target, low = 0) {
  let high = numbers.length - 1

  while (low < high) {
    let sum = numbers[low] + numbers[high]

    if (sum === target)
      return [numbers[low], numbers[high]]
    else if (sum < target)
      low += 1
    else if (sum > target)
      high -= 1
  }
  return null
}

let input = fs.readFileSync(path.join(__dirname, 'input.txt'), 'utf8')

let numbers = input.match(/\d+/g).map((n) => parseInt(n, 10))
numbers = numbers.sort((a, b) => a - b)

let [a, b] = pairWithSum(numbers, 2020)
console.log(a * b)

for (let [i, n] of numbers.entries()) {
  let pair = pairWithSum(numbers, 2020 - n, i + 1)
  if (!pair) continue

  let [a, b] = pair
  console.log(n * a * b)
}
