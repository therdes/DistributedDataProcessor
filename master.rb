require 'socket'
require_relative 'config'
require_relative 'utils'

include Utils
class MasterProcessor
  def initialize
    raise 'No such file' unless File.exist? ConfigSingleton::MASTER_INI

    File.open(ConfigSingleton::MASTER_INI) { |file| @config = parse_ini file }

    @socket = TCPServer.open @config[:port].to_i
  end

  def start
    ret = process
    ret.reduce(:+) / ret.size.to_f
  end

  private
  def process
    result = Array.new
    m = Mutex.new
    until result.size == @config[:slave].to_i do
      Thread.start(@socket.accept) do |client|
        loop do
          s = client.gets.chomp
          case
            when s.start_with?(ConfigSingleton::STATE[:PROCESSING])
              puts 'Slave is processing'
            when s.start_with?(ConfigSingleton::STATE[:COMPLETE])
              num = s.split.last.to_i
              m.synchronize { result << num }
              break
            else
              raise 'Unknown argument'
          end
        end
        client.close
      end.join
    end
    result
  end
end

master = MasterProcessor.new
result = master.start
p result