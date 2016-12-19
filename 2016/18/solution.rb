input_path = File.expand_path('../input.txt', __FILE__)
rows = File.read(input_path).strip.lines

PATTERNS = ['^^.', '.^^', '^..', '..^']

def new_row(row)
  cells = row.size.times.map do |i|
    window = [i-1, i, i+1].map { |j| j < 0 ? '.' : (row[j] || '.') }.join('')
    PATTERNS.include?(window) ? '^' : '.'
  end
  cells.join('')
end

until rows.size == 400000
  rows << new_row(rows.last)
end

p rows.inject(0) { |s, r| s + r.scan('.').size }

__END__

    ...     
    ..^     1
    .^.
    .^^     1
    ^..     1
    ^.^
    ^^.     1
    ^^^
