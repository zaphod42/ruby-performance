require 'benchmark'

iterations = 1_000_000

class FibError
  def dofib(n)
    begin
      fib(n)
    rescue ArgumentError
    end
  end

  def fib(n)
    case n
    when 0, 1
      raise ArgumentError
    else
      fib(n-1) + fib(n-2)
    end
  end
end

class FibException
  def dofib(n)
    if catch :bottom do
        fib(n)
      end
      # extra if, to level playing field - to know if catch was executed or not, then
      # doing nothing just as for the exception raising example
    end
  end

  def fib(n)
    case n
    when 0, 1
      throw :bottom, :is_reached
    else
      fib(n-1) + fib(n-2)
    end
  end
end

Benchmark.bm(30) do |x|
  x.report("long jump with throw") { iterations.times { FibException.new.dofib(5) } }
  x.report("long jump with exception") { iterations.times { FibError.new.dofib(5) } }
end
