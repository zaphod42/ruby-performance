require 'benchmark'

iterations = 10_000_000

Benchmark.bm(30) do |x|
  x.report("'misss' == :undef") { iterations.times { 'misss' == :undef } }
  x.report(":undef == 'misss'") { iterations.times { :undef == 'misss' } }
  x.report(":unded == :undef")  { iterations.times { :undead == :undef } }
end
