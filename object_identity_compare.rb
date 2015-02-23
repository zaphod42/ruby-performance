require 'benchmark'

iterations = 30_000_000

x = 'the value'
y = x
z = x.clone
Benchmark.bm(34) do |x|
  x.report("x.object_id == y.object_id (true)") { iterations.times { x.object_id == y.object_id } }
  x.report("x.object_id == z.object_id (false)") { iterations.times { x.object_id == z.object_id } }
  x.report("x.equal?(y) (true)") { iterations.times { x.equal?(y) } }
  x.report("x.equal?(z) (false)") { iterations.times { y.equal?(z) } }
end

