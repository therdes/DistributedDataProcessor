module BinFile
  CHARACTER_SIZE = 1
  SHORT_SIZE = 2
  INTEGER_SIZE = 4
  LONG_SIZE = 8

  def BinFile.write_fix_size(file, size, data)
    template_str =
        case size
          when CHARACTER_SIZE then 'C'
          when SHORT_SIZE then 'S'
          when INTEGER_SIZE then 'L'
          when LONG_SIZE then 'Q'
          else
            raise 'Unknown argument'
        end
    file.print [data].pack(template_str)
  end

  def BinFile.read_fix_size(file, size)
    intStr = ''
    (0...size).each do
      intStr.insert 0, file.read(1)
    end

    num = 0
    intStr.each_byte do |byte|
      num = num * 256 + byte
    end
    num
  end
end
