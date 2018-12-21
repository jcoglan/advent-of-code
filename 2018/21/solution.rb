require 'set'

log = Set.new

x = 0
loop do
  unless log.add?(x)
    p log.to_a.last
    exit
  end
  y = x | 65536
  x = 7041048
  loop do
    x = (((x + (y & 255)) & 16777215) * 65899) & 16777215
    break if y < 256
    y /= 256
  end
end
