require 'benchmark'

iterations = 100_000

# Premise construct hash from another hash, changing all values

data = {}
1..100.times {|t| data[:"k#{t}"] = t }
frozen_data = data.dup
frozen_data.freeze

Benchmark.bm(30) do |x|
  x.report('each (update self)') { iterations.times { data.each { |k, v| data[k] = v + 1 } } }
  x.report('each (create copy)') { iterations.times { r = {}; data.each { |k, v| r[k] = v + 1 } } }
  x.report('each (create copy from frozen source)') { iterations.times { r = {}; frozen_data.each { |k, v| r[k] = v + 1 } } }
  x.report('Hash[] {|k,v| ...}') { iterations.times { r = Hash[data.map { |k,v| [k, v + 1 ] }] } }
  x.report('Hash[] {|e| ...}') { iterations.times { r = Hash[data.map { |e| e[1] = e[1] + 1; e }] } }
  x.report('merge') { iterations.times { r = data.merge(data) { |k,v| v + 1 } } }
end
