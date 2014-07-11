require 'benchmark'

iterations = 1000000

VAL1 = 'a'.freeze
VAL2 = 'b'.freeze
VAL3 = 'c'.freeze
VAL4 = 'd'.freeze
VAL5 = 'e'.freeze
VAL6 = 'f'.freeze
VAL7 = 'g'.freeze
VAL8 = 'h'.freeze

LOOKUP = 'h'

Benchmark.bm(30) do |x|
  x.report("when constant") { iterations.times do
    case LOOKUP
    when VAL1
     1
    when VAL2
     2
    when VAL3
     3
    when VAL4
     4
    when VAL5
     5
    when VAL6
     6
    when VAL7
     7
    when VAL8
     8
    end
    end
  }
  x.report("when literal") { iterations.times do
    case LOOKUP
    when 'a'
     1
    when 'b'
     2
    when 'c'
     3
    when 'd'
     4
    when 'e'
     5
    when 'f'
     6
    when 'g'
     7
    when 'h'
     8
    end
    end
  }
  x.report("when frozen inline") { iterations.times do
    case LOOKUP
    when 'a'.freeze
     1
    when 'b'.freeze
     2
    when 'c'.freeze
     3
    when 'd'.freeze
     4
    when 'e'.freeze
     5
    when 'f'.freeze
     6
    when 'g'.freeze
     7
    when 'h'.freeze
     8
    end
    end
  }

end
