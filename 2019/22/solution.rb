input_path = File.expand_path('../input.txt', __FILE__)

shuffle = File.read(input_path).lines.map do |line|
  case line
    when /deal into new stack/       then [:new]
    when /cut (-?\d+)/               then [:cut, $1.to_i]
    when /deal with increment (\d+)/ then [:inc, $1.to_i]
  end
end


def new_stack(cards)
  cards.reverse
end

def cut(n, cards)
  n %= cards.size
  cards.drop(n) + cards.take(n)
end

def inc(n, cards)
  shuffled = Array.new(cards.size)

  cards.each_with_index do |card, i|
    offset = (i * n) % cards.size
    shuffled[offset] = card
  end

  shuffled
end

cards = (0 ... 10_007).to_a

cards = shuffle.reduce(0 ... 10_007) do |cards, line|
  case line
    in [:new]    then new_stack(cards)
    in [:cut, n] then cut(n, cards)
    in [:inc, n] then inc(n, cards)
  end
end

p cards.index(2019)


def moddiv(a, b, m)
  inv = b.pow(m - 2, m)
  (a * inv) % m
end

# f(x) = ax + b
# f^2(x) = f(f(x)) = a(ax + b) + b = aax + ab + b
# g(x) = cx + d
# f(g(x) = a(cx + d) + b = acx + ad + b

def modpow(a, b, n, m)
  if n == 0
    [1, 0]
  elsif n % 2 == 0
    modpow((a * a) % m, (a * b + b) % m, n / 2, m)
  else
    c, d = modpow(a, b, n - 1, m)
    [(a * c) % m, (a * d + b) % m]
  end
end


N = 101_741_582_076_661
M = 119_315_717_514_047

a, b = shuffle.reverse.reduce([1, 0]) do |(a, b), line|
  case line
    in [:new]    then [-a % M, M - 1 - b]
    in [:cut, n] then [a, (b + n) % M]
    in [:inc, n] then [moddiv(a, n, M), moddiv(b, n, M)]
  end
end

a, b   = modpow(a, b, N, M)
number = (a * 2020 + b) % M

p [a, b]
p number
