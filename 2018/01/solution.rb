require 'set'

input_path = File.expand_path('../input.txt', __FILE__)
changes    = File.read(input_path).lines.map(&:to_i)

freq  = 0
freqs = Set.new([freq])

loop do
  changes.each do |change|
    freq += change
    next if freqs.add?(freq)

    puts freq
    exit
  end
end
