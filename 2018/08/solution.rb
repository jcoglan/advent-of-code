input_path = File.expand_path('../input.txt', __FILE__)
numbers = File.read(input_path).scan(/\d+/).map(&:to_i)

Node = Struct.new(:children, :meta) do
  def value
    return meta.reduce(0, :+) if children.empty?

    meta.reduce(0) do |sum, n|
      child = (n > 0) ? children[n - 1] : nil
      sum + (child&.value || 0)
    end
  end
end

def parse(numbers)
  n = numbers.shift
  m = numbers.shift

  children = (1..n).map { parse(numbers) }
  meta = (1..m).map { numbers.shift }

  Node.new(children, meta)
end

def meta(node)
  node.meta + node.children.flat_map { |n| meta(n) }
end

tree = parse(numbers)
p meta(tree).reduce(0, :+)
p tree.value
