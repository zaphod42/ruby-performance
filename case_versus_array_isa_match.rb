require 'benchmark'

iterations = 3000000

class CustomScalar
  attr_reader :x
  def initialize(x)
    @x = x
  end

  def hash
    x.hash
  end

  def eql?(o)
    o.is_a?(CustomScalar) && o.x == @x
  end
  alias == eql?
end

vals = ['hello', 23, 12.4, CustomScalar.new(2), :symbol, [1, 2, 3], {'a' => 'value a', 'b' => 'value b', 'c' => 'value c' }, true, false, nil]
TRUE_TYPES = [Numeric, FalseClass, TrueClass, String, Regexp, Symbol, CustomScalar].freeze
FALSE_TYPES = [Array, Hash, NilClass, Module].freeze
TYPES_HASH = { Fixnum => true, Float => true, Time => true, Bignum => true, FalseClass => true, TrueClass => true, String => true, Regexp => true, Symbol => true, CustomScalar => true,
  Hash => false, Array => false, NilClass => false, Module => false}.freeze

vals.each do |val|
  puts
  puts "Using instance of class #{val.class}"
  Benchmark.bm(27) do |x|
    x.report("if/elsif/else is_a?") do
      iterations.times do
        if val.is_a?(Numeric) || val.is_a?(FalseClass) || val.is_a?(TrueClass) || val.is_a?(String) || val.is_a?(Regexp) || val.is_a?(Symbol) || val.is_a?(CustomScalar)
          true
        elsif val.is_a?(Array) || val.is_a?(Hash) || val.is_a?(NilClass) || val.is_a?(Module)
          false
        else
          val
        end
      end
    end

    x.report("if/elsif/else ===") do
      iterations.times do
        if Numeric === val || FalseClass === val || TrueClass === val || String === val || Regexp === val || Symbol === val || CustomScalar === val
          true
        elsif Array === val || Hash === val || NilClass === val || Module === val
          false
        else
          val
        end
      end
    end

    x.report("if/elsif/else true/false/nil") do
      iterations.times do
        if val.is_a?(Numeric) || val == false || val == true || val.is_a?(String) || val.is_a?(Regexp) || val.is_a?(Symbol) || val.is_a?(CustomScalar)
          true
        elsif val.is_a?(Array) || val.is_a?(Hash) || val.nil? || val.is_a?(Module)
          false
        else
          val
        end
      end
    end

    x.report("case/when") do
      iterations.times do
        case val
        when Numeric, FalseClass, TrueClass, String, Regexp, Symbol, CustomScalar
          true
        when Array, Hash, NilClass, Module
          false
        else
          val
        end
      end
    end

    x.report("case/when true/false/nil") do
      iterations.times do
        case val
        when Numeric, false, true, String, Regexp, Symbol, CustomScalar
          true
        when Array, Hash, nil, Module
          false
        else
          val
        end
      end
    end

    x.report("Hash#fetch(class)") do
      iterations.times do
        TYPES_HASH.fetch(val.class) { val }
      end
    end

    x.report("Hash#[class]") do
      iterations.times do
        result = TYPES_HASH[val.class]
        if result.nil?
          val
        else
          result
        end
      end
    end

    x.report("Array#any?") do
      iterations.times do
        if TRUE_TYPES.any? { |cls| val.is_a?(cls) }
          true
        elsif FALSE_TYPES.any?  { |cls| val.is_a?(cls) }
          false
        else
          val
        end
      end
    end
  end
end
