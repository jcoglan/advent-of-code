Chip = Struct.new(:value) do
  include Comparable

  def <=>(other)
    value <=> other.value
  end
end

class Bot
  attr_reader :id
  attr_accessor :low_receiver, :high_receiver

  BOTS    = Hash.new { |h,k| h[k] = new(k) }
  OUTPUTS = Hash.new { |h,k| h[k] = [] }

  def initialize(id)
    @id    = id
    @chips = []
  end

  def give(chip, should_proceed = true)
    @chips << chip
    proceed if should_proceed
  end

  def proceed
    return unless @chips.size == 2

    low, high = @chips.minmax
    @chips = []

    if low.value == 17 and high.value == 61
      p self
    end

    (low_type, low_id), (high_type, high_id) = low_receiver, high_receiver

    if low_type == 'bot'
      BOTS[low_id].give(low)
    else
      OUTPUTS[low_id] << low
    end

    if high_type == 'bot'
      BOTS[high_id].give(high)
    else
      OUTPUTS[high_id] << high
    end
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

chips = Hash.new { |h,k| h[k] = Chip.new(k) }

lines.each do |line|
  case line

  when /value (\d+) goes to bot (\d+)/
    Bot::BOTS[$2.to_i].give(chips[$1.to_i], false)

  when /bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)/
    giver = Bot::BOTS[$1.to_i]
    giver.low_receiver  = [$2, $3.to_i]
    giver.high_receiver = [$4, $5.to_i]
  end
end

Bot::BOTS.each { |id,b| b.proceed }

p (0..2).inject(1) { |s, id| s * Bot::OUTPUTS[id].first.value }
