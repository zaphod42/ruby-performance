require 'benchmark'

iterations = 1_000_000

data = 'astringthatislongandcontainsquiteALOTOFTEXTAndIfItIsLonger'
data2 = 'as::tr::ingthatislongandcontainsquiteALOTOFTEXTAndIfItIsLonger'

Benchmark.bm(30) do |x|
  x.report("match with w") { iterations.times { data  =~ /[\w]*/ } }
  x.report("match with explicit a-z") { iterations.times { data  =~ /[a-zA-Z0-9_]*/ } }
  x.report("non match with w") { iterations.times { data2  =~ /[\w]*/ } }
  x.report("non match with explicit a-z") { iterations.times { data2  =~ /[a-zA-Z0-9_]*/ } }
end
