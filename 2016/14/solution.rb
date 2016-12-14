require 'digest/md5'

salt       = 'yjdafjpo'
factor     = 2017
limit      = 64
candidates = []
confirmed  = []
counter    = 0

until confirmed.size >= limit
  hash   = factor.times.inject("#{salt}#{counter}") { |s,_| Digest::MD5.hexdigest s }
  groups = hash.chars.chunk { |c| c }.to_a
  n3     = groups.find { |_,g| g.size >= 3 }
  n5     = groups.find { |_,g| g.size >= 5 }

  if n3
    candidates << [counter, n3.first, hash]
  end

  if n5
    confirmed += candidates.select do |n, c, h|
      c == n5.first && (counter - 1000 ... counter).include?(n)
    end
  end

  confirmed.sort_by!(&:first)

  counter += 1
end

p confirmed[limit - 1]
