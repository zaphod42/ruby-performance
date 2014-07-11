require 'benchmark'

FORMAT = "%s[%s]"
OPEN = "["
CLOSE = "]"

FROZEN_FORMAT = "%s[%s]".freeze
FROZEN_OPEN = "[".freeze
FROZEN_CLOSE = "]".freeze

iterations = 50_000
value = "hello"*16
values = []
1..100.times { values << value }
values2 = values + values
 
first = "hi"
second = "there"
Benchmark.bm(24) do |x|
  x.report("join") { iterations.times { values.join } }
  x.report("join more data") { iterations.times { values2.join } }
  x.report("join('')") { iterations.times { values.join('') } }
  x.report("reduce") { iterations.times { values.reduce(&:'+') } }
  x.report("mutation") { iterations.times { buffer = ""; values.each {|v| buffer << v} } }
  x.report("mutation more data") { iterations.times { buffer = ""; values2.each {|v| buffer << v} } }
end
