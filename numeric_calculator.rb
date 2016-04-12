require './buffer_reader'

module NumericCalculator

  class AverageCalculator
    def initialize(data, data_type)
      @reader = BufferReader.new data, data_type
    end

    def calc
      n = @reader.count
      sum = 0
      (0...n).each { |i| sum += @reader[i] }

      sum / n.to_f
    end
  end
end

