require 'set'

Generator = Struct.new(:type) do
  def inspect
    "G{#{type.to_s[0..2]}}"
  end
end

Microchip = Struct.new(:type) do
  def inspect
    "m{#{type.to_s[0..2]}}"
  end
end

class Floor < Set
  def inspect
    map(&:inspect) * ', '
  end

  def legal?
    g_types = grep(Generator).map(&:type)
    m_types = grep(Microchip).map(&:type)

    g_types.none? || (m_types - g_types).none?
  end
end

State = Struct.new(:floors, :current, :parent) do
  def inspect
    fs = floors.map.with_index.reverse_each.map do |floor, i|
      "#{i == current ? '->' : '  '}  #{i+1}  #{floor.inspect}"
    end
    sep = '-' * 72
    ([sep] + fs + [sep]) * "\n"
  end

  def legal_next_states
    floor  = floors[current]
    combos = (1..2).flat_map { |n| floor.to_a.combination(n).to_a }

    [+1, -1].flat_map do |offset|
      generate_next_states(combos, current + offset).compact
    end
  end

  def generate_next_states(combos, index)
    floor  = floors[current]
    target = index >= 0 && floors[index]

    return [] unless target

    combos.map do |set|
      new_floors = floors.map(&:dup)

      new_floors[current] -= set
      new_floors[index]   += set

      if [current, index].all? { |i| new_floors[i].legal? }
        State.new(new_floors, index, self)
      else
        nil
      end
    end
  end

  def complete?
    floors[0..-2].all?(&:none?)
  end

  def steps
    (parent ? parent.steps : []) + [self]
  end

  def hash
    current.hash + canonical.hash
  end

  def eql?(other)
    current == other.current && canonical == other.canonical
  end
  alias :== :eql?

  def canonical
    @canonical ||= begin
      positions = Hash.new { |h,k| h[k] = [] }

      floors.each.with_index do |floor, i|
        floor.each do |item|
          positions[item.type][item.class == Generator ? 0 : 1] = i
        end
      end

      positions.values.sort
    end
  end
end

G = Generator.method(:new)
M = Microchip.method(:new)

floors_example = [
  Floor.new([ M.(:hydrogen), M.(:lithium) ]),
  Floor.new([ G.(:hydrogen) ]),
  Floor.new([ G.(:lithium) ]),
  Floor.new([ ])
]

floors_jc = [
  Floor.new([ G.(:promethium), M.(:promethium) ]),
  Floor.new([ G.(:cobalt), G.(:curium), G.(:ruthenium), G.(:plutonium) ]),
  Floor.new([ M.(:cobalt), M.(:curium), M.(:ruthenium), M.(:plutonium) ]),
  Floor.new([ ])
]

floors_jc2 = [
  Floor.new([ G.(:promethium), M.(:promethium), G.(:elerium), M.(:elerium), G.(:dilithium), M.(:dilithium) ]),
  Floor.new([ G.(:cobalt), G.(:curium), G.(:ruthenium), G.(:plutonium) ]),
  Floor.new([ M.(:cobalt), M.(:curium), M.(:ruthenium), M.(:plutonium) ]),
  Floor.new([ ])
]

states  = [State.new(floors_jc2, 0, nil)]
visited = Set.new(states)

loop do
  states = states.flat_map { |s| s.legal_next_states }
                 .select { |s| visited.add?(s) }

  break if states.any?(&:complete?)
end

state = states.find(&:complete?) || states.first

state.steps.each.with_index do |s, i|
  p [:step, i]
  p s
end
