require 'benchmark'

# Premise? 
# How to best construct an array when the size of the result is known beforehand.
# Is it possible to avoid growing the array?

iterations = 100_000

Benchmark.bm(24) do |x|
  x.report("mutate") { iterations.times { a = []; 1..1000.times { a << true } } }
  x.report("prealloc clear") { iterations.times { a = Array(1000); a.clear; 1..1000.times { a << true } } }
  x.report("prealloc at")   { iterations.times { a = Array(1000); 0..999.times {|i| a[i] = true } } }
end
