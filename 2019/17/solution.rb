require_relative '../02/intcode'
require_relative './camera'
require_relative './planner'
require_relative './optimiser'
require_relative './driver'

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

image  = {}
camera = Camera.new(program)
camera.run(image)

intersections = image.keys.select do |x, y|
  next false unless image[[x, y]] == PATH

  ROBOT.values.reduce(true) do |result, (dx, dy)|
    result && image[[x + dx, y + dy]] == PATH
  end
end

alignment = intersections.map { |x, y| x * y }.reduce(:+)
p alignment

planner = Planner.new(image)
plan = planner.run

optimiser = Optimiser.new(plan)
procs = optimiser.run

driver = Driver.new(program, procs, video: false)
driver.run
