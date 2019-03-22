class Mapreduce_hw1

  attr_accessor :result

  def initialize
    @result = {}
  end

  def inversed_index(line, lineno)
    line_hash = {}

    stripped_line = line.gsub(",", "").gsub(".","")
    line_number = lineno
    words = stripped_line.split(" ")

    words.each do |word|
      unless @result.has_key?(word)
        @result[word] = Array(line_number)
      else
        hash = Hash[word => [line_number]]
        @result.merge!(hash) do |key, oldval, newval|
          oldval.push(newval)
        end
      end
    end
  end

  def map
  end

  def reduce
  end

end

def search(word)
  hw1 = Mapreduce_hw1.new
  file = File.open("text.txt")
  
  file.each_line do |line|
    hw1.inversed_index(line, file.lineno)
  end
  hw1.result[word]
end

puts search("the")
