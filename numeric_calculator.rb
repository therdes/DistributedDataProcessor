require_relative 'buffer_reader'
require_relative 'buffer_writer'

module NumericCalculator

  class AverageCalculator
    def self.calc(data, data_type, elem_len = 0)
      @reader = BufferReader.new data, data_type, elem_len

      n = @reader.count
      sum = 0
      (0...n).each { |i| sum += @reader[i] }
      @reader.close

      sum / n.to_f
    end
  end

  class MedianCalculator
    THRESHOLD = 44

    def self.calc(data, data_type, elem_len)
      reader = BufferReader.new data, data_type, elem_len
      n = reader.count
      ret = select_k data, data_type, elem_len, n / 2
      if n.even? then
        num = select_k data, data_type, elem_len, n / 2 - 1
        ret = (ret + num) / 2
      end
      ret
    end

    private
    def self.select_k(tmpfile, data_type, elem_len, k)
      tmp_reader = BufferReader.new tmpfile, data_type, elem_len
      count = tmp_reader.count
      q = (count / 5).floor
    end
  end
end

