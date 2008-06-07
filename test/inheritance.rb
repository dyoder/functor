require 'test/helpers'

class A
  include Functor::Method
  functor( :test, Integer ) { |x| "A: Integer" }
  functor( :test, String ) { |s| "A: String" }
end

class B < A
  include Functor::Method
  functor( :test, String ) { |s| "B: String" }
end

describe "Functor methods should support inheritance" do
  
  before do
    @b = B.new
  end
  
  specify "by inheriting base class implementations" do
    @b.test( 5 ).should == "A: Integer"
  end
  
  specify "by allowing derived classes to override an implementation" do
    @b.test( "foo" ).should == "B: String"
  end
  
end
  
