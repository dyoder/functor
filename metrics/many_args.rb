require "#{here = File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor( :foo, 1, 2, 3, 4, 5, 6, 7 )                { |*x| "ints" }
  functor( :foo, :a, :b, :c, :d, :e, :f, :g )         { |*x| "symbols" }
  functor( :foo, *%w{ a b c d e f g } )               { |*x| "strings" }
  functor( :foo, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0 )  { |*x| "floats" }
  functor( :foo, *Array.new(7, "one") )               { |*x| "ones" }
end

class Native
  def foo(*args)
    case args
    when [1, 2, 3, 4, 5, 6, 7]
      "ints"
    when [:a, :b, :c, :d, :e, :f, :g]
      "symbols"
    when %w{ a b c d e f g }
      "strings"
    when [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0]
      "floats"
    when Array.new(7, "one")
      "ones"
    else
      raise ArgumentError
    end
  end
end

class ManyArgs < Steve
end

ManyArgs.new "native method" do
  before do
    @args = [
      [1, 2, 3, 4, 5, 6, 7],
      [:a, :b, :c, :d, :e, :f, :g],
      %w{ a b c d e f g },
      [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0],
      Array.new(7, "one")
      ]
    @n = Native.new
  end
  measure do
    400.times do
      @args.each { |args| @n.foo *args }
    end
  end
end


ManyArgs.new "functor method" do
  before do
    @args = [
      [1, 2, 3, 4, 5, 6, 7],
      [:a, :b, :c, :d, :e, :f, :g],
      %w{ a b c d e f g },
      [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0],
      Array.new(7, "one")
      ]
    @a = A.new
  end
  measure do
    400.times do
      @args.each { |args| @a.foo *args }
    end
  end
end

ManyArgs.compare_instances( 16, 32)