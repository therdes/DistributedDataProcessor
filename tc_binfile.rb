require_relative 'binfile'
require 'test/unit'

class TestBinFile < Test::Unit::TestCase
  def test_simple
    file = File.open 'tc_binfile.dat', mode: 'wb+'

    test_case = [1,2,3,4,5,6,7,8,9,10]
    elem_len = 4
    test_case.each do |item|
      file.seek 0, IO::SEEK_END
      BinFile.write_fix_size file, elem_len, item
      file.seek -elem_len, IO::SEEK_CUR
      assert_equal BinFile.read_fix_size(file, elem_len), item
    end
  end
end