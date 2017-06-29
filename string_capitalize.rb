require 'benchmark'

iterations = 5_000_000

data = 'aaxxx'

def firstToUpper(str)
  str[0..0].upcase + ( str[1..-1] || '' )
end

Benchmark.bm(30) do |x|
  x.report("firstToUpper") { iterations.times { firstToUpper(data) } }
  x.report("capitalize") { iterations.times { data.capitalize } }
  x.report("capitalize!") { iterations.times { data.capitalize! } }
end
