require_relative 'buffer_reader'
require_relative 'buffer_writer'

require_relative 'binfile'

require 'test/unit'

class TestReader < Test::Unit::TestCase
  def setup
    # @test_case = [0,100,999,2147483648]
    @test_case = [1,2,3,4,5,6,7,8,9,10]
  end

  def test_binary
    file_name = 'tc_buffer_accessor.dat'
    elem_len = 4
    file = File.open file_name, mode: 'wb'
    @test_case.each do |item|
      BinFile.write_fix_size file, elem_len, item
    end
    file.close

    reader = BufferReader.new file_name, ConfigSingleton::DATA_TYPE[:BINARY], elem_len
    n = reader.count
    assert_equal n, @test_case.size
    0.upto n-1 do |index|
      assert_equal reader[index], @test_case[index]
    end
  end

  def test_string
    file_name = 'tc_buffer_accessor.txt'
    file = File.open file_name, mode: 'wb'
    @test_case.each do |item|
      file.puts item
    end
    file.close

    reader = BufferReader.new file_name, ConfigSingleton::DATA_TYPE[:STRING]
    n = reader.count
    assert_equal n, @test_case.size
    0.upto n-1 do |index|
      assert_equal reader[index], @test_case[index]
    end
  end
end

class TestWriter < Test::Unit::TestCase
  def setup
    # @test_case = [0,100,2345,2147483648]
    @test_case = [1,2,3,4,5,6,7,8,9,10]
  end

  def test_binary
    file_name = 'test_buffer_accessor.dat'
    elem_len = 4
    writer = BufferWriter.new file_name, ConfigSingleton::DATA_TYPE[:BINARY], elem_len
    @test_case.each do |item|
      writer.write item
    end
    writer.close

    reader = BufferReader.new file_name, ConfigSingleton::DATA_TYPE[:BINARY], elem_len
    n = reader.count
    assert_equal n, @test_case.size
    0.upto n-1 do |index|
      assert_equal @test_case[index], reader[index]
    end
  end

  def test_string
    file_name = 'test_buffer_accessor.txt'
    writer = BufferWriter.new file_name, ConfigSingleton::DATA_TYPE[:STRING]
    @test_case.each do |item|
      writer.write item
    end
    writer.close

    reader = BufferReader.new file_name, ConfigSingleton::DATA_TYPE[:STRING]
    n = reader.count
    assert_equal n, @test_case.size
    0.upto n-1 do |index|
      assert_equal reader[index], @test_case[index]
    end
  end
end