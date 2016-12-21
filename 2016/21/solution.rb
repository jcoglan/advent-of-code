input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

Scrambler = Struct.new(:lines) do
  def scramble(string)
    lines.each do |line|
      case line
      when /swap position (\d+) with position (\d+)/
        swap_position(string, $1.to_i, $2.to_i)
      when /swap letter (.) with letter (.)/
        swap_letter(string, $1, $2)
      when /reverse positions (\d+) through (\d+)/
        reverse(string, $1.to_i, $2.to_i)
      when /move position (\d+) to position (\d+)/
        move(string, $1.to_i, $2.to_i)
      when /rotate (left|right) (\d+) steps?/
        rotate(string, $1, $2.to_i)
      when /rotate based on position of letter (.)/
        rotate_index(string, $1)
      end
    end
  end

  def swap_position(string, i, j)
    a = string[i]
    string[i] = string[j]
    string[j] = a
  end

  def swap_letter(string, s1, s2)
    i, j = string.index(s1), string.index(s2)
    string[i] = s2
    string[j] = s1
  end

  def reverse(string, i, j)
    string[i..j] = string[i..j].reverse
  end

  def move(string, i, j)
    a = string.delete_at(i)
    string.insert(j, a)
  end

  def rotate(string, d, x)
    s = (d == 'left') ? 1 : -1
    string.rotate! s * x
  end

  def rotate_index(string, a)
    i = string.index(a)
    string.rotate! -rotate_offset(i)
  end

  def rotate_offset(i)
    1 + i + (i < 4 ? 0 : 1)
  end
end

class Unscrambler < Scrambler
  def lines
    super.reverse
  end

  def move(string, i, j)
    super(string, j, i)
  end

  def rotate(string, d, x)
    d = (%w[left right] - [d]).first
    super(string, d, x)
  end

  def rotate_index(string, a)
    map = {}
    string.size.times do |i|
      map[(i + rotate_offset(i)) % string.size] = i
    end

    i = string.index(a)
    string.rotate!(i - map[i])
  end
end


string = 'abcdefgh'.chars
Scrambler.new(lines).scramble(string)
p string.join('')


string = 'fbgdceah'.chars
Unscrambler.new(lines).scramble(string)
p string.join('')
