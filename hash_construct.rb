require 'benchmark'

iterations = 100_000

# Premise construct hash out of two values from each object in an array

class Mock
 attr_accessor :k, :v, :counter

 def initialize
   @@counter ||= 0
   @k = "key#{@@counter}"
   @v = "val#{@@counter}"
   @@counter += 1
 end
end

class MockFrozen
 attr_accessor :k, :v, :counter

 def initialize
   @@counter ||= 0
   @k = "key#{@@counter}".freeze
   @v = "val#{@@counter}".freeze
   @@counter += 1
 end
end

data = []
1..10.times {|t| data << (Mock.new()) }

data_frozen = []
1..10.times {|t| data << (MockFrozen.new()) }

Benchmark.bm(30) do |x|
  x.report("reduction frozen keys") { iterations.times { data_frozen.reduce({}) {|m, d| m[d.k] =  d.v; m } } }
  x.report("reduction") { iterations.times { data.reduce({}) {|m, d| m[d.k] =  d.v; m } } }
  x.report("reduction with freeze") { iterations.times { data.reduce({}) {|m, d| m[d.k.freeze] =  d.v; m } } }
  x.report("all at once array") { iterations.times { a = Array.new; data.each {|d| a << d.k << d.v}; Hash[*a]} }
  x.report("element by element") { iterations.times { h = Hash.new; data.each {|d| h[d.k] = h[d.v]} } }
  x.report("all at once subarray") { iterations.times { a = Array.new; data.each {|d| a << ([d.k, d.v])}; Hash[a]} }
end
