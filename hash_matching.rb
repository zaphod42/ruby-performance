require 'benchmark'

iterations = 100_000

# premise: when something has a complex key, should it be encoded as non ambiguous string keys, or
# can a class with precomputed hash be just as effective?
# Is using Struct an alternative

class TypedName
  attr_reader :type
  attr_reader :name
  attr_reader :name_parts

  # True if name is qualified (more than a single segment)
  attr_reader :qualified

  def initialize(name)
    @name_parts = name.to_s.split(/::/)
    @name_parts.shift if name_parts[0].empty?
    @name = name_parts.join('::').freeze
    @qualified = name_parts.size > 1
    # precompute hash - the name is frozen, so this is safe to do
    @hash = [self.class, @name].hash
    freeze()
  end

  def hash
    @hash
  end

  def eql?(o)
    name == o.name
  end

  alias == eql?

end

NameStruct = Struct.new(:name)

# 55 entries aa::aa to cc::cc
names = ('aa'..'cc').zip('aa'..'cc').map {|x| x.join('::').freeze }
prehashed = names.map {|n| TypedName.new(n) }
structs   = names.map {|n| NameStruct.new(n) }
arrays    = names.map {|n| n.split(/::/) }.each {|a| a[0].freeze; a[1].freeze }
arrays_frozen = arrays.map {|a| a.dup.freeze }

name_hash      = names.reduce({})     {|h, name| h[name] = name; h }
prehashed_hash = prehashed.reduce({}) {|h, name| h[name] = name; h }
struct_hash    = prehashed.reduce({}) {|h, name| h[name] = name; h }
array_hash     = arrays.reduce({})    {|h, arr| h[arr] = arr; h }
array_hash_f   = arrays_frozen.reduce({}) {|h, arr| h[arr] = arr; h }

Benchmark.bm(30) do |x|
  x.report("construct with strings")     { iterations.times { names.reduce({}) {|h, name| h[name] = name; h } } }
  x.report("construct with string hash") { iterations.times { prehashed.reduce({}) {|h, name| h[name] = name; h } } }
  x.report("construct with structs")     { iterations.times { structs.reduce({}) {|h, name| h[name] = name; h } } }
  x.report("construct with arrays")      { iterations.times { arrays_frozen.reduce({}) {|h, name| h[name] = name; h } } }

  x.report("lookup with strings")   { iterations.times { names.each {|n| name_hash[n] } } }
  x.report("lookup with prehashed") { iterations.times { prehashed.each {|n| prehashed_hash[n]  }} }
  x.report("lookup with prehashed.name") { iterations.times { prehashed.each {|n| prehashed_hash[n.name]  }} }
  x.report("lookup with prehashed.map name") { iterations.times { prehashed.map(&:name).each {|n| prehashed_hash[n]  }} }
  x.report("lookup with structs")        { iterations.times { structs.each {|n| struct_hash[n]  }} }
  x.report("lookup with arrays")         { iterations.times { arrays.each {|n| array_hash[n]  }} }
  x.report("lookup with frozen arrays")  { iterations.times { arrays_frozen.each {|n| array_hash_f[n]  }} }

  x.report("freeze cost x #{iterations}")        { iterations.times { "abc::def".freeze  } }
  x.report("construct key cost x #{iterations}") { a = "abc"; b = "def"; iterations.times { "#{a}::#{b}".freeze  } }

end
