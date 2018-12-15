class Game
  DEFAULT_POWERS = { 'E' => 3, 'G' => 3 }

  attr_reader :map

  def initialize(input, powers = DEFAULT_POWERS)
    @map    = Map.new(input)
    @powers = powers
    @rounds = 0
  end

  def play(&block)
    catch(:stop) { loop { play_round(&block) } }
  end

  def play_round
    units = @map.round_units
    count = units.size
    done  = 0

    units.each_with_index do |unit|
      unless unit.unit?
        count -= 1
        next
      end

      done += 1
      @rounds += 1 if done == count

      unit   = @map.move(unit)
      killed = @map.attack(unit, @powers[unit.state])

      throw :stop if yield killed
      throw :stop if @map.ended?
    end
  end

  def outcome
    points = @map.round_units.reduce(0) { |s, u| s + u.points }
    [@rounds, points, @rounds * points]
  end
end
