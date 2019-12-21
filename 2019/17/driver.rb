class Driver
  NAMES = ('A' .. 'Z').to_a

  def initialize(program, procs, video: false)
    @machine = Intcode.new(program, inputs: self, outputs: self)
    @procs   = procs
    @video   = video

    serialize
  end

  def run
    @machine.memory[0] = 2
    @machine.run
  end

  def push(value)
    if value < 0xff
      print value.chr
    else
      p [value]
    end
  end

  def shift
    @program.shift
  end

  def serialize
    functions = []
    main = []

    @procs.each_with_index do |(body, offsets), i|
      functions << body
      main.concat(offsets.map { |o| [NAMES[i], o] })
    end

    main = main.sort_by(&:last).map(&:first)

    @program = [
      main.join(','),
      *functions.map { |f| f.join(',') },
      @video ? 'y' : 'n',
      ''
    ].join("\n").codepoints
  end
end
