require 'socket'
require './config'
require './utils'
require './numeric_calculator'

include Utils
include NumericCalculator
class SlaveProcessor

  def initialize
    raise 'No such file' unless File.exist? ConfigSingleton::SLAVE_INI

    File.open(ConfigSingleton::SLAVE_INI) { |file| @config = parse_ini file }

    @socket = TCPSocket.open @config[:master], @config[:port].to_i
  end

  def start(file, data_type)
    process file, data_type
  end

  private
  def process(data, data_type)
    ave = AverageCalculator.new data, data_type
    @socket.puts '%s' % ConfigSingleton::STATE[:PROCESSING]
    result = ave.calc
    @socket.puts '%s %d' % [ConfigSingleton::STATE[:COMPLETE], result]
  end
end

slave = SlaveProcessor.new
slave.start 'buffer_reader_test_string.txt', ConfigSingleton::DATA_TYPE[:STRING]