require 'benchmark'

iterations = 1_000_000

data = 'a'..'x'

Benchmark.bm(30) do |x|
  x.report("map with sym to proc") { iterations.times { data.map(&:upcase) } }
  x.report("map with proc") { iterations.times { data.map {|x| x.upcase } } }
end
