require "#{File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor( :foo, Integer ) { |x| [ A, Integer ] }
  functor( :foo, String ) { |s| [ A, String ] }
  functor( :foo, Float ) { |h| [ A, Float ] }
end

class B < A
  functor( :foo, String ) { |s| [ B, String ] }
  # functor( :foo, Float ) { |x| super.reverse }
end

describe "Functor methods should support inheritance" do
  
  specify "by inheriting base class implementations" do
    B.new.foo( 5 ).should == [ A, Integer ]
  end
  
  specify "by allowing derived classes to override an implementation" do
    B.new.foo( "bar" ).should == [ B, String ]
  end
  
  # specify "by allowing #super" do
  #   B.new.foo(3.0).should == [ Float, A]
  # end
  
end
