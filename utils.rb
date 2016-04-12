module Utils

  # @param [File] file
  # @return [Hash]
  def parse_ini(file)
    ret = Hash.new
    file.each_line do |line|
      cur = line.chomp.split '='
      ret[cur.first.to_sym] = cur.last
    end

    ret
  end
end