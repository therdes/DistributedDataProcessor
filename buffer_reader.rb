require_relative 'config'
require_relative 'binfile'

raise 'conflict method in IO' if IO.respond_to? :readlines_in_count
class IO
  def readlines_in_count(count)
    ret = []
    begin
      until count == 0 do
        ret << self.readline
        count -= 1
      end
    rescue EOFError
      return ret
    end
    ret
  end
end

class BufferReader
  def initialize(file, data_type, elem_len = 0)
    data_type == ConfigSingleton::DATA_TYPE[:STRING] ?
        @imp = StringBufferReaderImpl.new(file) :
        @imp = BinaryBufferReaderImpl.new(file, elem_len)
  end

  def count
    @imp.count
  end

  def [](index)
    @imp[index]
  end

  def close
    @imp.close
  end
end

class BufferReaderImpl
  MAX_BUFFER = 256

  def initialize(file)
  end

  def count
  end

  def [](index)
  end

  def close
  end
end

class BinaryBufferReaderImpl < BufferReaderImpl
  def initialize(file, elem_len)
    raise 'No such file' unless File.exist? file

    @file = File.open file, mode: 'rb'
    @count = @file.size / elem_len
    @element_bytes = elem_len
    @buffer = Array.new MAX_BUFFER
    @cur_range = nil
  end

  def count
    @count
  end

  def [](index)
    raise RangeError if index >= count
    return @buffer[index-@cur_range.begin] if @cur_range && @cur_range.include?(index)

    cur = 0
    cur += MAX_BUFFER until cur <= index && (cur+MAX_BUFFER) > index
    @file.seek cur*MAX_BUFFER
    count = 0
    loop do
      @buffer[count] = BinFile.read_fix_size @file, @element_bytes
      break if @file.eof?
      count += 1
      break if count == MAX_BUFFER
    end

    @cur_range = (cur...cur+MAX_BUFFER)
    @buffer[index-cur]
  end

  def close
    @file.close
  end
end

class StringBufferReaderImpl < BufferReaderImpl
  def initialize(file)
    raise 'No such file' unless File.exist? file

    @file = File.open file, mode: 'r'
    @count = 0
    @file.each_line { |line| @count += 1 }
    @file.seek 0
    @buffer = Array.new MAX_BUFFER
    @cur_range = nil
  end

  def count
    @count
  end

  def [](index)
    raise RangeError if index >= count

    return @buffer[index-@cur_range.begin] if !@cur_range.nil? && (@cur_range.include? index)

    @file.seek 0
    cur = 0
    data = Array.new
    loop do
      data = @file.readlines_in_count MAX_BUFFER
      break if cur <= index && (cur + MAX_BUFFER) > index
      cur += MAX_BUFFER
    end
    data.map.with_index { |item, i| @buffer[i] = item.to_i }
    @cur_range = (cur...cur+MAX_BUFFER)

    @buffer[index-@cur_range.begin]
  end

  def close
    @file.close
  end
end

