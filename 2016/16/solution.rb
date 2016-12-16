a = '10111100110001111'
limit = 35651584

until a.size >= limit
  b = a.chars.map { |c| c == '0' ? '1' : '0' }.join('')
  a = [a, '0', b.reverse].join('')
end

def checksum(string)
  string.each_slice(2).map { |x, y| x == y ? '1' : '0' }
end

sum = checksum(a.chars.take(limit))
sum = checksum(sum) until sum.size.odd?

p sum.join('')
