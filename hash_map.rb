require 'benchmark'

iterations = 100_000

# Premise map a hash's keys and values


# Construct a hash
data = {}
100.times {|x| data[x] = x *2 }

Benchmark.bm(30) do |x|
  x.report("reduction")            { iterations.times { data.reduce({}) {|m, (k, v)| m[k+1] =  v+1; m } } }
  x.report("each_pair")            { iterations.times { result = {}; data.each_pair {|k, v| result[k+1] =  v+1 } } }
  x.report("all at once array")    { iterations.times { Hash[ data.map {|k,v| [ k+1, v+1 ] } ] } }
end
