require 'benchmark'

EMPTY = ''
EMPTY_FROZEN = ''.freeze


iterations = 10_000_000
value        = "hi"
frozen_value = "hi".freeze

Benchmark.bm(30) do |x|
  x.report("thawed.empty?") { iterations.times { value.empty? } }
  x.report("frozen.empty?") { iterations.times { frozen_value.empty? } }
  x.report("thawed  == thawed literal") { iterations.times { value == '' } }
  x.report("frozen  == thawed literal") { iterations.times { frozen_value == '' } }
  x.report("thawed  == frozen constant") { iterations.times { value == EMPTY_FROZEN } }
  x.report("frozen  == frozen constantl") { iterations.times { frozen_value == EMPTY_FROZEN } }
  x.report("thawed  == thawed constant") { iterations.times { value == EMPTY } }
  x.report("frozen  == thawed constantl") { iterations.times { frozen_value == EMPTY } }
end
