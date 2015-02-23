require 'benchmark'

def splat_receiver(*args)
end

def splat_dispatch(*args)
  splat_dispatch1(*args)
end

def splat_dispatch1(*args)
  splat_dispatch2(*args)
end

def splat_dispatch2(*args)
  splat_receiver(*args)
end

def array_dispatch(*args)
  array_dispatch1(args)
end

def array_dispatch1(args)
  array_dispatch2(args)
end

def array_dispatch2(args)
  splat_receiver(*args)
end

NO_ARGS = []

iterations = 10_000_000

Benchmark.bm(25) do |x|
  x.report("splat call") { iterations.times { splat_dispatch('a', 'b')} }
  x.report("args call") { iterations.times { array_dispatch('a', 'b')} }
  x.report("splat empty dispatch") { iterations.times { splat_dispatch1()} }
  x.report("array empty dispatch") { iterations.times { array_dispatch1([])} }
  x.report("array empty dispatch const") { iterations.times { array_dispatch1(NO_ARGS)} }
end

