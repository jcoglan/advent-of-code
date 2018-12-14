class Generator
  attr_reader :scores

  def initialize(scores, &block)
    @scores = []
    @reader = block
    @a, @b  = 0, 1

    scores.each { |n| push(n) }
  end

  def run_until
    until yield
      x, y = @scores[@a], @scores[@b]
      sum  = x + y

      push(sum / 10) if sum >= 10
      push(sum % 10)

      @a = (@a + 1 + x) % @scores.size
      @b = (@b + 1 + y) % @scores.size
    end
  end

  def push(n)
    @scores << n
    @reader&.call(n)
  end
end

class Pattern
  attr_reader :count

  def initialize(target)
    @target = target.to_s.chars.map(&:to_i)
    @count  = 0
    @cursor = 0
  end

  def size
    @target.size
  end

  def <<(n)
    return if complete?

    @count += 1
    @cursor = (n == @target[@cursor]) ? @cursor + 1 : 0
  end

  def complete?
    @cursor == @target.size
  end
end

target = 320851

gen = Generator.new([3, 7])

gen.run_until { gen.scores.size >= target + 10 }
p gen.scores[-10 .. -1]

pattern = Pattern.new(target)
gen = Generator.new([3, 7]) { |n| pattern << n }

gen.run_until { pattern.complete? }
p pattern.count - pattern.size
