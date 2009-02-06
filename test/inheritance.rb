require "#{File.dirname(__FILE__)}/helpers"

class Parent
  include Functor::Method
  functor( :foo, Integer ) { |x| [ Parent, Integer ] }
  functor( :foo, String ) { |s| [ Parent, String ] }
  functor( :foo, Float ) { |h| [ Parent, Float ] }
end

class Child < Parent
  functor( :foo, String ) { |s| [ Child, String ] }
  functor( :foo, Float ) { |x| super(x).reverse }
end

describe "Functor methods should support inheritance" do
  
  specify "by inheriting base class implementations" do
    Child.new.foo( 5 ).should == [ Parent, Integer ]
  end
  
  specify "by allowing derived classes to override an implementation" do
    Child.new.foo( "bar" ).should == [ Child, String ]
  end
  
  specify "by allowing #super" do
    Child.new.foo(3.0).should == [ Float, Parent]
  end
  
end
