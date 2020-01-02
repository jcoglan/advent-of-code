require_relative '../02/intcode'

class Channel
  attr_reader :failures

  def initialize
    @mutex    = Mutex.new
    @inbox    = []
    @failures = 0
  end

  def send(values)
    @mutex.synchronize do
      @inbox.concat(values)
      @failures = 0
    end
  end

  def recv
    @mutex.synchronize do
      if @inbox.empty?
        @failures += 1
        nil
      else
        @inbox.shift
      end
    end
  end
end

class NIC
  attr_reader :channel

  def initialize(network, address, program)
    @network = network
    @address = address
    @machine = Intcode.new(program, inputs: self, outputs: self)
    @packet  = []
    @channel = Channel.new
  end

  def run
    @channel.send([@address])
    Thread.new { @machine.run }
  end

  def call(packet)
    @channel.send(packet)
  end

  def shift
    @channel.recv || -1
  end

  def push(value)
    @packet << value
    return unless @packet.size == 3

    address = @packet.shift
    message = @packet.clone
    @packet = []

    @network[address]&.call(message)
  end
end

def part_one(program)
  network = []

  50.times do |address|
    network << NIC.new(network, address, program)
  end

  network[255] = lambda do |packet|
    p packet
    part_two(program)
  end

  network.grep(NIC).map(&:run).each(&:join)
end

class NAT
  def initialize(network)
    @network   = network
    @last_sent = nil

    @mutex  = Mutex.new
    @packet = nil
  end

  def call(packet)
    @mutex.synchronize { @packet = packet }
  end

  def run
    Thread.new { loop { check_idle } }
  end

  def check_idle
    sleep 1

    return unless @network.grep(NIC).all? { |nic| nic.channel.failures > 0 }

    packet = @mutex.synchronize { @packet }
    return unless packet

    if @last_sent and @last_sent[1] == packet[1]
      p packet
      exit
    end

    @last_sent = packet.clone
    @network[0].call(packet)
  end
end

def part_two(program)
  network = []

  50.times do |address|
    network << NIC.new(network, address, program)
  end

  network[255] = NAT.new(network)

  network.compact.map(&:run).each(&:join)
end

input_path = File.expand_path('../input.txt', __FILE__)
program    = File.read(input_path)

part_one(program)
