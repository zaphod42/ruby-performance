require 'benchmark'
require 'stringio'

FORMAT = "%s[%s]"
OPEN = "["
CLOSE = "]"

FROZEN_FORMAT = "%s[%s]".freeze
FROZEN_OPEN = "[".freeze
FROZEN_CLOSE = "]".freeze

iterations = 10_000_000
first = "hi"
second = "there"
Benchmark.bm(24) do |x|
  x.report("interpolation") { iterations.times { "#{first}[#{second}]" } }
  x.report("stringio") { iterations.times { s = StringIO.new; s << first << second } }
  x.report("concatenation") { iterations.times { first + "[" + second + "]" } }
  x.report("concatenation(')") { iterations.times { first + '[' + second + ']' } }
  x.report("join") { iterations.times { [first, "[", second, "]"].join } }
  x.report("sprintf") { iterations.times { sprintf("%s[%s]", first, second) } }
  x.report("mutation") { iterations.times { "" << first << "[" << second << "]" } }

  x.report("stringio(const)") { iterations.times { s = StringIO.new; s << first << OPEN << second << CLOSE } }
  x.report("concatenation(const)") { iterations.times { first + OPEN + second + CLOSE } }
  x.report("join(const)") { iterations.times { [first, OPEN, second, CLOSE].join } }
  x.report("sprintf(const)") { iterations.times { sprintf(FORMAT, first, second) } }
  x.report("mutation(const)") { iterations.times { "" << first << OPEN << second << CLOSE } }

  x.report("stringio(const)") { iterations.times { s = StringIO.new; s << first << FROZEN_OPEN << second << FROZEN_CLOSE } }
  x.report("concatenation(froze)") { iterations.times { first + FROZEN_OPEN + second + FROZEN_CLOSE } }
  x.report("join(froze)") { iterations.times { [first, FROZEN_OPEN, second, FROZEN_CLOSE].join } }
  x.report("sprintf(froze)") { iterations.times { sprintf(FROZEN_FORMAT, first, second) } }
  x.report("mutation(froze)") { iterations.times { "" << first << FROZEN_OPEN << second << FROZEN_CLOSE } }
end

Benchmark.bm(24) do |x|
  top_iterations = iterations / 100_000
  sub_iterations = iterations / top_iterations
end