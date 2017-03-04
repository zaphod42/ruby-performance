require 'benchmark'

iterations = 1000000

vals = ['hello', [1, 2, 3], {'a' => 'value a', 'b' => 'value b', 'c' => 'value c' }, true, false, nil]
TRUE_TYPES = [Numeric, FalseClass, TrueClass, String, Regexp, Symbol, Enumerator].freeze
FALSE_TYPES = [Array, Hash, NilClass, Module].freeze
TYPES_HASH = { Fixnum => true, Float => true, Time => true, Bignum => true, FalseClass => true, TrueClass => true, String => true, Regexp => true, Symbol => true, Enumerator => true,
Hash => false, Array => false, NilClass => false, Module => false}.freeze

vals.each do |val|
  Benchmark.bm(43) do |x|
    x.report("case/when #{val.class}") do
      iterations.times do
        case val
        when Numeric, FalseClass, TrueClass, String, Regexp, Symbol, Enumerator
          true
        when Array, Hash, NilClass, Module
          false
        else
          val
        end
      end
    end
    x.report("case/when with true/false/nil #{val.class}") do
      iterations.times do
        case val
        when Numeric, false, true, String, Regexp, Symbol, Enumerator
          true
        when Array, Hash, nil, Module
          false
        else
          val
        end
      end
    end

    x.report("if/elsif/else #{val.class}") do
      iterations.times do
        if val.is_a?(Numeric) || val.is_a?(FalseClass) || val.is_a?(TrueClass) || val.is_a?(String) || val.is_a?(Regexp) || val.is_a?(Symbol) || val.is_a?(Enumerator)
          true
        elsif val.is_a?(Array) || val.is_a?(Hash) || val.is_a?(NilClass) || val.is_a?(Module)
          false
        else
          val
        end
      end
    end

    x.report("if/elsif/else with true/false/nil #{val.class}") do
      iterations.times do
        if val.is_a?(Numeric) || val == false || val == true || val.is_a?(String) || val.is_a?(Regexp) || val.is_a?(Symbol) || val.is_a?(Enumerator)
          true
        elsif val.is_a?(Array) || val.is_a?(Hash) || val.nil? || val.is_a?(Module)
          false
        else
          val
        end
      end
    end

    x.report("Array##any? #{val.class}") do
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

    x.report("Hash#[class] #{val.class}") do
      iterations.times do
        result = TYPES_HASH[val.class]
        if result.nil?
          val
        else
          result
        end
      end
    end
  end
end
