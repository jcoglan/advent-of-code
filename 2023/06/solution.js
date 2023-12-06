'use strict'

/*    T = time limit
      H = hold time
      X = distance

      X = H * (T - H) = TH - H^2

      => X vs H is an inverted parabola

              dX/dH = T - 2H

          =>  to maximise X, find T - 2H = 0
                              =>  H = T/2

      to find H that beat the record (R), need to solve:

              TH - H^2 > R

          =>  H^2 - TH + R = 0

      via quadratic formula:

              H = (T ± sqrt(T^2 - 4R)) / 2
*/

//  input:
//
//  Time:        61     67     75     71
//  Distance:   430   1036   1307   1150 

let records = [
  { time: 61, distance: 430 },
  { time: 67, distance: 1036 },
  { time: 75, distance: 1307 },
  { time: 71, distance: 1150 }
]

function tolerance ({ time, distance }) {
  const { sqrt, ceil, floor } = Math

  let discrim = sqrt(time ** 2 - 4 * distance)

  let low = (time - discrim) / 2
  low = (ceil(low) === low) ? low + 1 : ceil(low)

  let high = (time + discrim) / 2
  high = (floor(high) === high) ? high - 1 : floor(high)

  return 1 + high - low
}

let tolerances = records.map((record) => tolerance(record))
let product = tolerances.reduce((a, b) => a * b)
console.log({ product })

let combined = {
  time: parseInt(records.map(r => r.time).join(''), 10),
  distance: parseInt(records.map(r => r.distance).join(''), 10)
}

console.log({ combined: tolerance(combined) })
