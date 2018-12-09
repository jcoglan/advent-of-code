class Circle
  def initialize
    @values  = []
    @current = 0
  end

  def insert(value, offset = nil)
    index = offset ? (@current + offset) % @values.size : @current
    @values.insert(index, value)
    @current = index
  end

  def remove(offset)
    index    = (@current + offset) % @values.size
    value    = @values.delete_at(index)
    @current = index % @values.size

    value
  end
end

class Ring
  Node = Struct.new(:value, :prev, :next)

  def initialize
    @current = nil
  end

  def insert(value, offset = nil)
    if @current
      node = @current
      offset.times { node = node.next }

      @current = Node.new(value, node.prev, node)
      @current.prev.next = @current
      @current.next.prev = @current
    else
      @current = Node.new(value)
      @current.prev = @current.next = @current
    end
  end

  def remove(offset)
    node = @current
    offset.abs.times { node = (offset < 0) ? node.prev : node.next }

    node.prev.next = node.next
    node.next.prev = node.prev

    @current = node.next
    node.value
  end
end

class Players
  def initialize(n)
    @scores  = Array.new(n, 0)
    @current = 0
  end

  def score(n)
    @scores[@current] += n
    @current = (@current + 1) % @scores.size
  end

  def high_score
    @scores.max
  end
end

class Game
  def initialize(players)
    @players = Players.new(players)
    @circle  = Ring.new

    @circle.insert(0)
  end

  def play(marble)
    if marble % 23 == 0
      score = @circle.remove(-7)
      @players.score(marble + score)
    else
      @circle.insert(marble, 2)
      @players.score(0)
    end
  end

  def high_score
    @players.high_score
  end
end

game = Game.new(430)
(1..7158800).each { |i| game.play(i) }
p game.high_score
