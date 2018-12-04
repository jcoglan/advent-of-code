input_path = File.expand_path('../input.txt', __FILE__)

PATTERN = /^\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\] (.*)$/

events = File.read(input_path).lines.map do |line|
  values = PATTERN.match(line).captures
  event  = values.pop

  values.map { |v| v.to_i 10 } + [event]
end

events.sort!

totals = Hash.new { |h, k| h[k] = 0 }
times  = Hash.new { |h, k| h[k] = Hash.new { |h, k| h[k] = 0 } }
guard = nil
sleep = nil

events.each do |year, month, day, hour, minute, event|
  case event
  when /Guard #(\d+) begins shift/
    guard = $1.to_i
  when /falls asleep/
    sleep = minute
  when /wakes up/
    totals[guard] += minute - sleep
    (sleep...minute).each { |m| times[guard][m] += 1 }
  end
end

guard, total  = totals.max_by(&:last)
minute, count = times[guard].max_by(&:last)

p [guard, minute, guard * minute]

records = times.map do |guard, times|
  minute, count = times.max_by(&:last)
  [guard, minute, count]
end

guard, minute, count = records.max_by(&:last)
p [guard, minute, guard * minute]
