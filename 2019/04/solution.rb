input = 357253 .. 892942

passwords = input.select do |n|
  c = n.to_s.chars

  if c.map(&:to_i).each_cons(2).any? { |a, b| a > b }
    false
  elsif c.chunk { |k| k }.none? { |_, k| k.size == 2 }
    false
  else
    true
  end
end

p passwords.size
