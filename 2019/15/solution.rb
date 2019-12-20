require_relative '../02/intcode'

class State
  attr_reader :position, :result

  def initialize(cells, position, machine)
    @cells    = cells
    @position = position
    @machine  = machine

    @machine.outputs = self
  end

  def move(code, position)
    machine = @machine.clone
    machine.inputs = [code]
    State.new(@cells, position, machine).tap { |state| state.run }
  end

  def run
    catch(:stop) { @machine.run }
  end

  def push(value)
    @result = @cells[@position] = value
    throw :stop
  end
end

NORTH = [1,  0, -1]
SOUTH = [2,  0, +1]
WEST  = [3, -1,  0]
EAST  = [4, +1,  0]

WALL = 0
OPEN = 1
TANK = 2

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

machine = Intcode.new(program)
cells   = {}
states  = [State.new(cells, [0, 0], machine)]
counter = 0
tank    = nil

until states.empty?
  counter += 1

  states = states.flat_map do |state|
    x, y = state.position

    [NORTH, SOUTH, WEST, EAST].flat_map do |code, dx, dy|
      pos = [x + dx, y + dy]
      next [] if cells.has_key?(pos)

      new_state = state.move(code, pos)
      cell = cells[new_state.position]

      if tank == nil and cell == TANK
        tank = new_state
        p counter
      end

      cell == WALL ? [] : [new_state]
    end
  end
end

filled  = [tank.position]
counter = 0

while cells.has_value?(OPEN)
  filled = filled.flat_map do |x, y|
    [NORTH, SOUTH, WEST, EAST].flat_map do |_, dx, dy|
      pos = [x + dx, y + dy]
      cells[pos] == OPEN ? [pos] : []
    end
  end
  filled.each { |pos| cells[pos] = TANK }
  counter += 1
end

p counter
