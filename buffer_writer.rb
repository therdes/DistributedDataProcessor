require_relative 'config'
require_relative 'binfile'

class BufferWriter
  def initialize(file, data_type, elem_len = 0)
    @imp =
        data_type == ConfigSingleton::DATA_TYPE[:STRING] ?
            StringBufferWriterImpl.new(file) :
            BinaryBufferWriterImpl.new(file, elem_len)
  end

  def write(data)
    @imp.write data
  end

  def close
    @imp.close
  end
end

class BufferWriterImpl
  def initialize(file)
  end

  def write(data)
  end

  def close
  end
end

class BinaryBufferWriterImpl < BufferWriterImpl
  def initialize(file, elem_len)
    @file = File.open file, mode: 'wb'
    @element_length = elem_len
  end

  def write(data)
    @file.seek 0, IO::SEEK_END
    BinFile.write_fix_size @file, @element_length, data
  end

  def close
    @file.close
  end
end

class StringBufferWriterImpl < BufferWriterImpl
  def initialize(file)
    @file = File.open file, mode: 'w+'
  end

  def write(data)
    @file.seek 0, IO::SEEK_END
    @file.write data.to_s + "\n"
  end

  def close
    @file.close
  end
end

