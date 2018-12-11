serial = 7400
size   = 300

cells = (1..size).map do |y|
  (1..size).map do |x|
    rack_id = x + 10
    ((rack_id * y + serial) * rack_id / 100) % 10 - 5
  end
end

index = (size + 1).times.map { Array.new(size + 1, 0) }

cells.each_with_index do |row, y|
  row.each_with_index do |_, x|
    p = cells.fetch(y, []).fetch(x, 0)

    a = index[y - 1][x - 1]
    b = index[y - 1][x]
    c = index[y][x - 1]

    index[y][x] = p - a + b + c
  end
end

records = (1..size).map do |s|
  totals = cells.flat_map.with_index do |row, y|
    row.map.with_index do |_, x|
      next [] if x + s >= size or y + s >= size

      px = x + s - 1
      py = y + s - 1

      a = index[py - s][px - s]
      b = index[py - s][px]
      c = index[py][px - s]

      total = index[py][px] + a - b - c
      [s, x + 1, y + 1, total]
    end
  end

  totals.reject(&:empty?).max_by(&:last)
end

p records[2]
p records.compact.max_by(&:last)
