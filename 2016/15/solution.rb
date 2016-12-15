Disc = Struct.new(:period, :current) do
  def value_at(time)
    (current + time) % period
  end
end

discs = [
  Disc.new(13, 10),
  Disc.new(17, 15),
  Disc.new(19, 17),
  Disc.new(7, 1),
  Disc.new(5, 0),
  Disc.new(3, 1),
  Disc.new(11, 0)
]

period = discs.inject(1) { |s,d| s * d.period }

period.times do |t|
  positions = discs.map.with_index { |d,i| d.value_at(t+i+1) }

  if positions.all?(&:zero?)
    p t
    break
  end
end
