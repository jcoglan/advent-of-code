Cart = Struct.new(:x, :y, :dir, :turns)
dirs = %i[^ > v <]

input_path = File.expand_path('../input.txt', __FILE__)
carts = []

grid = File.read(input_path).lines.map.with_index do |line, y|
  line.chars.map.with_index do |char, x|
    case char
    when '^', '>', 'v', '<'
      carts << Cart.new(x, y, char.to_sym, [-1, 0, 1])
      %w[< >].include?(char) ? '-' : '|'
    else
      char
    end
  end
end

loop do
  carts.sort_by { |cart| [cart.y, cart.x] }.each do |cart|
    case cart.dir
    when :^ then cart.y -= 1
    when :> then cart.x += 1
    when :v then cart.y += 1
    when :< then cart.x -= 1
    end

    carts.each do |other|
      next if cart == other
      carts -= [cart, other] if [cart.x, cart.y] == [other.x, other.y]
    end

    cell = grid[cart.y][cart.x]
    idx  = nil

    case cell
    when '/', '\\'
      turn = %i[< >].include?(cart.dir) ? 1 : -1
      flip = (cell == '/') ? -1 : 1
      idx  = dirs.index(cart.dir) + turn * flip
    when '+'
      idx = dirs.index(cart.dir) + cart.turns.first
      cart.turns.rotate!
    end

    cart.dir = dirs[idx % dirs.size] if idx
  end

  next unless carts.size == 1

  p carts
  exit
end
