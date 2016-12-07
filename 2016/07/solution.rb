IP = Struct.new :string do
  def tls?
    supernets.any?(&method(:has_abba?)) and hypernets.none?(&method(:has_abba?))
  end

  def ssl?
    babs = abas(hypernets)

    abas(supernets).any? do |aba|
      babs.any? { |bab| aba_bab_compat?(aba, bab) }
    end
  end

  def abas(chunks)
    chunks.flat_map do |str|
      str.chars.each_cons(3).select(&method(:palindrome?))
    end
  end

  def supernets
    string.split(/\[.*?\]/)
  end

  def hypernets
    string.scan(/\[(.*?)\]/).flatten
  end

  def has_abba?(chunk)
    chunk.chars.each_cons(4).any?(&method(:palindrome?))
  end

  def aba_bab_compat?(aba, bab)
    aba[0..1] == bab[0..1].reverse
  end

  def palindrome?(x)
    x[0] != x[1] and x == x.reverse 
  end
end

input_path = File.expand_path('../input.txt', __FILE__)
lines = File.read(input_path).strip.lines

ips = lines.map { |l| IP.new(l) }

p ips.select(&:tls?).size
p ips.select(&:ssl?).size
