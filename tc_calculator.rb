require_relative 'numeric_calculator'
require 'test/unit'

class TestCalculator < Test::Unit::TestCase
  include NumericCalculator

  def setup
    @test_case = [1,2,3,4,5,6,7,8,9,10,11,12]
    @result = @test_case.reduce(:+) / @test_case.size.to_f

    @test_file = 'tc_calculator.dat'
    @element_length = 4
    @data_type = ConfigSingleton::DATA_TYPE[:BINARY]
    writer = BufferWriter.new @test_file, @data_type, @element_length
    @test_case.each { |item| writer.write item }
    writer.close
  end

  def test_average
    ave = AverageCalculator.calc @test_file, @data_type, @element_length
    assert_equal @result, ave
  end
end