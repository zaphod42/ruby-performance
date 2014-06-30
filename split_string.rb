require 'benchmark'

SEP = "::"
FROZEN_SEP = "::".freeze
long = (["word"] * 1000).join(SEP)
short = (["word"] * 4).join(SEP)

iterations = 100_000
Benchmark.bm(23) do |x|
  x.report("long/regex") { iterations.times { long.split(/::/) } }
  x.report("long/string") { iterations.times { long.split("::") } }
  x.report("long/string-constant") { iterations.times { long.split(SEP) } }
  x.report("long/string-frozen") { iterations.times { long.split(FROZEN_SEP) } }
  x.report("short/regex") { iterations.times { short.split(/::/) } }
  x.report("short/string") { iterations.times { short.split("::") } }
  x.report("short/string-constant") { iterations.times { short.split(SEP) } }
  x.report("short/string-frozen") { iterations.times { short.split(FROZEN_SEP) } }
end
