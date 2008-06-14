require 'test/helpers'

class A
  include Functor::Method
  functor( :test, Integer ) { |x| :a1 }
  functor( :test, String ) { |s| :a2 }
end

class B < A
  functor( :test, String ) { |s| :b2 }
end

describe "Functor methods should support inheritance" do
  
  before do
    @b = B.new
  end
  
  specify "by inheriting base class implementations" do
    @b.test( 5 ).should == :a1
  end
  
  specify "by allowing derived classes to override an implementation" do
    @b.test( "foo" ).should == :b2
  end
  
end
  
