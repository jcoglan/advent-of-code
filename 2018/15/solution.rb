require_relative './map'
require_relative './dijkstra'
require_relative './game'

input_path = File.expand_path('../input.txt', __FILE__)
elf_power  = 3

loop do
  powers = { 'E' => elf_power, 'G' => 3 }
  game   = Game.new(File.read(input_path), powers)
  died   = false

  game.play { |killed| died = (killed == 'E') }

  puts game.map
  p [elf_power, game.outcome]
  puts

  exit unless died

  elf_power += 1
end
