# Premise: what is the cost of delegating to a block after having interpolated a string
#
require 'benchmark'

iterations = 1_000_000

def find_lambda(x)
  [:foo, :bar, :fee].find {|y| y == x }
end

class CostOfWrapperCall
  def self.without_guard(message, &block)
    yield
  end
  def self.without_guard_and_arg(&block)
    yield
  end
end

GUARD = false

Benchmark.bm(24) do |x|
  x.report("without guard") { iterations.times { CostOfWrapperCall.without_guard("Some text and #{iterations} interpolation") { 0 } } }
  x.report("without guard no interpolation") { iterations.times { CostOfWrapperCall.without_guard('Some text and no interpolation') { 0 } } }
  x.report("without guard no arg") { iterations.times { CostOfWrapperCall.without_guard_and_arg() { 0 } } }
  x.report("with guard")    { iterations.times {  GUARD ? 0 : 0 } }
end
