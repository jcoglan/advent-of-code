class Optimiser
  def initialize(plan)
    @plan  = plan
    @used  = Array.new(@plan.size, false)
    @procs = []
  end

  def run
    find_repeats until @used.all?
    @procs
  end

  private

  def find_repeats
    offset = @used.index(false)
    slice  = nil
    best   = []

    (4 ..).each do |length|
      slice  = @plan.slice(offset, length)
      places = occurrences(slice)

      if best.empty? or places.size >= best.size
        best = places
      else
        break
      end
    end

    slice.pop
    @procs << [slice, best]

    best.each do |ofs|
      slice.size.times { |i| @used[ofs + i] = true }
    end
  end

  def occurrences(slice)
    offset = 0
    places = []

    while offset < @plan.size
      if match?(slice, offset)
        places << offset
        offset += slice.size
      else
        offset += 1
      end
    end

    places
  end

  def match?(slice, offset)
    range = offset ... offset + slice.size
    range.all? { |i| not @used[i] and @plan[i] == slice[i - offset] }
  end
end
