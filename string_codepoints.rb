require 'benchmark'

iterations = 5000
rep = 'the string that will be repeated and form a very long string'
value = ''
100.times { value << rep }

Benchmark.bm(34) do |x|
  x.report('codepoints.each.next') do
    iterations.times do
      cpe = value.codepoints.each
      begin
        while true
          c = cpe.next
        end
      rescue StopIteration
      end
    end
  end
  x.report('codepoints.each_with_index.next') do
    iterations.times do
      cpe = value.codepoints.each_with_index
      begin
        while true
          c, i = cpe.next
        end
      rescue StopIteration
      end
    end
  end

  x.report('codepoints.each_with_index.next and pushback') do
    class Pushback
      def initialize(str)
        @pushback = nil
        @codepoints = str.codepoints.each_with_index
      end

      def next
        if @pushback.nil?
          @codepoints.next
        else
          n = @pushback
          @pushback = nil
          n
        end
      end
    end

    iterations.times do
      cpe = Pushback.new(value)
      begin
        while true
          c, i = cpe.next
        end
      rescue StopIteration
      end
    end
  end
end
