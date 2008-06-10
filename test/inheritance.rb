require "#{File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor( :smurf, Integer ) { |x| "A: Integer" }
  functor( :smurf, String ) { |s| "A: String" }
end

class B < A
  functor( :smurf, String ) { |s| "B: String" }
end

describe "Functor methods should support inheritance" do
  
  before do
    @b = B.new
  end
    
  specify "by inheriting base class implementations" do
    @b.smurf( 5 ).should == "A: Integer"
  end
  
  specify "by allowing derived classes to override an implementation" do
    @b.smurf( "foo" ).should == "B: String"
  end
  
end
  
