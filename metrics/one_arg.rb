require "#{here = File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor( :foo, Integer ) { |x| :integer }
  functor( :foo, String )  { |x| :string }
  functor( :foo, Float )   { |x| :float }
  functor( :foo, Symbol )  { |x| :symbol }
  functor( :foo, "one"  )  { |x| :one }
end

class Native
  def foo(x)
    case x
    when Integer then :integer
    when String then :string
    when Float then :float
    when Symbol then :symbol
    when "one" then :one
    else
      raise ArgumentError
    end
  end
end

class OneArg < Steve
  
end

OneArg.new "native method" do
  before do
    @n = Native.new
  end
  measure do
    200.times do
      [ 1, 2, 3, 1.0, 2.0, 3.0, "1", "2", "3", :uno, :dos, :tres, "one"].each { |item| @n.foo item }
    end
  end
end

OneArg.new "functor method" do
  before do
    @a = A.new
  end
  measure do
    200.times do
      [ 1, 2, 1.0, 2.0, "1", "2", :uno, :dos, "one"].each { |item| @a.foo item }
    end
  end
end


OneArg.compare_instances( 16, 32)