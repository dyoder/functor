require "#{File.dirname(__FILE__)}/helpers"

class A
  def ==(v)
    v < 0
  end
  def ===(v)
    v < -1
  end
end

class B
  def ==(v)
    v > 1
  end
  def ===(v)
    v > 0
  end
end

class C
  include Functor::Method
  functor( :foo, A.new) { |a| "==" }
  functor( :foo, B.new) { |a| "===" }
  functor( :boo, lambda { |a| a == "boo" } ) { |v| "Lambda: #{v}" }
end

describe "Functors match" do
  
  specify "==" do
    C.new.foo( -1 ).should == "=="
  end
  
  specify "===" do
    C.new.foo( 1 ).should == "==="
    lambda { C.new.foo( 0 ).should }.should.raise(ArgumentError)
  end

  specify "lambda" do
    C.new.boo( "boo" ).should == "Lambda: boo"
  end

end
