RoomName = Struct.new(:string) do
  LETTERS = ('a'..'z').to_a

  def real?
    checksum_letters == most_common_letters
  end

  def northpole?
    string.split('-').map(&:size).take(3) == [9,6,7]
  end

  def decrypt
    text  = string.split(/-\d+/).first
    shift = sector_id

    text.chars.map.with_index { |char, i|
      next(' ') if char == '-'
      index = LETTERS.index(char) + shift
      LETTERS[index % LETTERS.size]
    }.join('')
  end

  def checksum_letters
    string.scan(/\[(.*?)\]/).flatten.first.chars
  end

  def most_common_letters
    letter_map.sort { |(c,n),(d,m)| n == m ? c <=> d : m <=> n }
              .take(5)
              .map { |p| p[0] }
  end

  def letter_map
    text = string.split(/\d/).first
    map  = Hash.new { |h,k| h[k] = 0 }

    text.chars.each do |char|
      next unless char =~ /[a-z]/
      map[char] += 1
    end

    map
  end

  def sector_id
    string.scan(/\d+/).first.to_i
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

rooms = lines.map { |l| RoomName.new(l) }

p rooms.inject(0) { |s,r| s + r.sector_id }
p rooms.select(&:real?).inject(0) { |s,r| s + r.sector_id }

rooms.each do |room|
  p [room.decrypt, room.sector_id]
end

p rooms.select(&:northpole?)
