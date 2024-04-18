module M1
  def m1(n)
    "M1#{n}"
  end
end

module M2
  def m2(s)
    s.to_i
  end
end

class Base
  attr_reader :a, :b

  def initialize(a, b = nil)
    @a = a
    @b = b
  end
end

class A < Base
  include M1
  extend M2
  prepend Enumerable

  attr_accessor :c
  attr_reader :d, :f

  def initialize(a, b = nil, c:, d:, f:)
    super(a, b)
    @c = c
    @d = d
    @f = f
  end

  def foo(foo)
    n = foo[:i] || 0
    s = "#{foo[:s]}#{n}"
    r = @f.call(s)
    FormattableString.new(r)
  end

  def self.bar
    rand(2) == 0 ? "str" : 123
  end

  def each
    yield 1
    yield 2
    yield 3
  end
end
