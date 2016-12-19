require 'digest/md5'

State = Struct.new(:x, :y, :path) do
  MAX_POS   = 3
  MOTIONS   = %w[U D L R]
  OPEN_CHAR = /[b-f]/

  DIFFS = {'U' => [0,-1], 'D' => [0,1], 'L' => [-1,0], 'R' => [1,0]}

  PASSCODE = 'awrkjxxr'

  def complete?
    [x, y] == [MAX_POS, MAX_POS]
  end

  def explore
    return [self] if complete?

    hash = Digest::MD5.hexdigest(PASSCODE + path.join(''))

    hash.chars.take(4)
        .zip(MOTIONS)
        .select { |c, m| c =~ OPEN_CHAR }
        .map(&:last)
        .map { |m| [m, x + DIFFS[m][0], y + DIFFS[m][1]] }
        .select { |m, x, y| [x,y].all? { |v| v.between?(0, MAX_POS) } }
        .map { |m, x, y| State.new(x, y, path + [m]) }
  end
end


states = [State.new(0, 0, [])]

until states.any?(&:complete?)
  states = states.flat_map(&:explore)
end

p states.find(&:complete?).path.join('')


states = [State.new(0, 0, [])]

until states.all?(&:complete?)
  states = states.flat_map(&:explore)
end

p states.select(&:complete?).map { |s| s.path.size }.max
