require 'benchmark'
require 'strscan'

iterations = 10_000

func = lambda { true }
array = []
hash = {}
str_hash = {}
hash_wdflt = Hash.new { |h, k| func }
str_hash_wdflt = Hash.new { |h, k| func }
128.times do |index|
  array[index] = func
  hash[index] = func
  hash_wdflt[index] = func
  str_hash[''.concat(index).freeze] = func
  str_hash_wdflt[''.concat(index).freeze] = func
end

buf128 = ''
buf256 = ''
rnd = Random.new
4096.times do
  buf128.concat(rnd.rand(128))
  buf256.concat(rnd.rand(256))
end
last7bit = ''.concat(127).freeze



Benchmark.bm(50) do |x|
  x.report('array access') { iterations.times { buf128.codepoints { |c| array[c].call } } }
  x.report('array access with overflow') { iterations.times { buf256.codepoints { |c| (c < 128 ? array[c] : func).call } } }
  x.report('hash access') { iterations.times { buf128.codepoints { |c| hash[c].call } } }
  x.report('hash string access') { iterations.times { buf128.each_char { |c| str_hash[c].call } } }
  x.report('hash access with overflow') { iterations.times { buf256.codepoints { |c| (c < 128 ? hash[c] : func).call } } }
  x.report('hash access with overflow 2') { iterations.times { buf256.codepoints { |c| (hash[c] || func).call } } }
  x.report('hash access with overflow and default') { iterations.times { buf256.codepoints { |c| hash_wdflt[c].call } } }
  x.report('hash string access with overflow') { iterations.times { buf256.each_char { |c| (c <= last7bit ? str_hash[c] : func).call } } }
  x.report('hash string access with overflow 2') { iterations.times { buf256.each_char { |c| (str_hash[c] || func).call } } }
  x.report('hash string access with overflow and default') { iterations.times { buf256.each_char { |c| str_hash_wdflt[c].call } } }
  x.report('hash string access using scanner') { iterations.times { s = StringScanner.new(buf256); until s.eos? do c = s.getch; (str_hash[c] || func).call end } }
end
