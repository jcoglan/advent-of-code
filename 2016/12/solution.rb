input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

registers = {'a' => 0, 'b' => 0, 'c' => 1, 'd' => 0}
counter   = 0

loop do
  case lines[counter]

  when /cpy (\S+) (.)/
    value, dest = $1, $2
    registers[dest] = (value =~ /^\d+$/) ? value.to_i : registers[value]
    counter += 1

  when /inc (.)/
    registers[$1] += 1
    counter += 1

  when /dec (.)/
    registers[$1] -= 1
    counter += 1

  when /jnz (.) (-?\d+)/
    if registers[$1] == 0
      counter += 1
    else
      counter += $2.to_i
    end

  when nil
    break
  end
end

p registers
