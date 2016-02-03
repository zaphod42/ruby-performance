require 'benchmark'
require 'set'

class SymbolCase
  def self.by_case_1(sym)
    case sym
    when :sym1, :sym2, :sym3
      true
    else
      false
    end
  end

  def self.by_case_1b(sym)
    case sym; when :sym1, :sym2, :sym3; true; else false; end
  end

  def self.by_case_2(sym)
      case sym
      when :sym1
        true
      when :sym2
        true
      when :sym3
        true
      else
        false
      end
  end

  def self.find(sym)
    [:sym1, :sym2, :sym3].find {|s| s == sym }
  end

  A_set = Set.new [:sym1, :sym2, :sym3]
  An_array = [:sym1, :sym2, :sym3].freeze
  A_hsh = {:sym1 =>true, :sym2=>true, :sym3=>true}
  A_fhsh = {:sym1 =>true, :sym2=>true, :sym3=>true}.freeze

  def self.set(sym)
    A_set.include? sym
  end

  def self.hsh_val(sym)
    A_hsh[sym]
  end

  def self.fhsh_val(sym)
    A_fhsh[sym]
  end

  def self.hsh_incl(sym)
    A_hsh.include?(sym)
  end

  def self.index(sym)
    An_array.index(sym)
  end
end

iterations = 10_000_000

Benchmark.bm(30) do |x|
  x.report("case1")          { iterations.times { SymbolCase.by_case_1(:sym3) } }
  x.report("case1b")         { iterations.times { SymbolCase.by_case_1b(:sym3) } }
  x.report("case2")          { iterations.times { SymbolCase.by_case_2(:sym3) } }
  x.report("find")           { iterations.times { SymbolCase.find(:sym3) } }
  x.report("set")            { iterations.times { SymbolCase.set(:sym3) } }
  x.report("hash")           { iterations.times { SymbolCase.hsh_val(:sym3) } }
  x.report("hash frozen")    { iterations.times { SymbolCase.fhsh_val(:sym3) } }
  x.report("hash include")   { iterations.times { SymbolCase.hsh_incl(:sym3) } }
  x.report("array index")    { iterations.times { SymbolCase.index(:sym3) } }
end
