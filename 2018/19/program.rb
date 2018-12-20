n = 10551386

p (1..n).select { |x| n % x == 0 }.reduce(:+)
