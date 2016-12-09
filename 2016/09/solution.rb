MARKER = /\((\d+)x(\d+)\)/

def decompress(message)
  cursor = 0
  result = 0

  while cursor < message.size
    marker = message.match(MARKER, cursor)

    unless marker
      result += message.size - cursor
      break
    end

    offset = marker.begin(0)
    size   = marker[0].size
    chunk  = marker[1].to_i
    repeat = marker[2].to_i

    result += offset - cursor
    cursor = offset + size

    result += decompress(message[cursor...(cursor + chunk)]) * repeat
    cursor += chunk
  end

  result
end

input_path = File.expand_path('../input.txt', __FILE__)
message = File.read(input_path)

p decompress(message)
