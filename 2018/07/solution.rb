input_path = File.expand_path('../input.txt', __FILE__)

PATTERN = /Step (.) must be finished before step (.) can begin/
steps   = Hash.new { |h, k| h[k] = [] }

File.read(input_path).each_line do |line|
  match = PATTERN.match(line)
  steps[match[2]] << match[1]
  steps[match[1]]
end

order = []
todo  = steps.clone

until todo.empty?
  available = todo.select { |s, d| d.all? { |t| order.include? t } }
  picked = available.keys.min
  order << picked
  todo.delete(picked)
end

puts order.join("")

class Team
  Worker = Struct.new(:free_time)

  def initialize(n)
    @workers = (1..n).map { Worker.new(0) }
    @times   = {}
  end

  def complete_time
    @workers.map(&:free_time).max
  end

  def schedule(steps)
    schedule_next(steps) until steps.empty?
  end

  def schedule_next(steps)
    step, time = next_step(steps)
    worker     = @workers.min_by(&:free_time)

    time = [time, worker.free_time].max

    worker.free_time = time + 60 + (step.ord - 64)
    @times[step] = worker.free_time

    steps.delete(step)
  end

  def next_step(steps)
    times = available_times(steps)

    min_time = times.map(&:last).min
    times.select! { |_, time| time == min_time }

    times.min_by(&:first)
  end

  def available_times(steps)
    steps.map { |step, deps| [step, deps.map { |d| @times[d] }] }
         .select { |_, times| times.all? }
         .map { |step, times| [step, times.max || 0] }
  end
end

team = Team.new(5)
team.schedule(steps.clone)
puts team.complete_time
