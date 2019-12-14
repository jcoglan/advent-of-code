require 'forwardable'
require_relative '../02/intcode'

class Arcade
  EMPTY  = 0
  WALL   = 1
  BLOCK  = 2
  PADDLE = 3
  BALL   = 4

  extend Forwardable
  def_delegators :@machine, :memory, :run

  attr_reader :score

  def initialize(program)
    @machine = Intcode.new(program, inputs: self, outputs: self)
    @stack   = []
    @screen  = Hash.new { EMPTY }
    @score   = 0
  end

  def count(type)
    @screen.count { |_, v| v == type }
  end

  def push(value)
    @stack.push(value)
    return unless @stack.size == 3

    pos  = [@stack.shift, @stack.shift]
    type = @stack.shift

    if pos == [-1, 0]
      @score = type
    else
      @screen[pos] = type
    end
  end

  def shift
    ball, _   = cell(BALL)
    paddle, _ = cell(PADDLE)

    if ball < paddle
      -1
    elsif ball > paddle
      1
    else
      0
    end
  end

  private

  def cell(type)
    @screen.keys.find { |pos| @screen[pos] == type }
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

machine = Arcade.new(program)
machine.run
p machine.count(Arcade::BLOCK)

machine = Arcade.new(program)
machine.memory[0] = 2
machine.run
p machine.score
