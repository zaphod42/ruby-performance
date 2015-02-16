require 'benchmark'

iterations = 1_000_000

data = 'aaxxx'
data2 = 'bbxx'

CONST = "aa".freeze

Benchmark.bm(30) do |x|
  x.report("match with regexp") { iterations.times { data  =~ /^aa/ } }
  x.report("match each char") { iterations.times { data[0] == 'a' && data[1] == 'a' } }
  x.report("match substring") { iterations.times { data[0,2] == 'aa' } }
  x.report("match substring frozen") { iterations.times { data[0,2] == CONST } }
end
