require "#{File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor( :smurf, Integer ) { |x| "A: Integer" }
  functor( :smurf, String ) { |s| "A: String" }
  functor( :smurf, Symbol ) { |s| smurf( "boo" ) }
end

class B < A
  functor( :smurf, String ) { |s| "B: String" }
end

describe "Functor methods should support inheritance" do
  
  specify "by inheriting base class implementations" do
    B.new.smurf( 5 ).should == "A: Integer"
  end
  
  specify "by allowing derived classes to override an implementation" do
    B.new.smurf( "foo" ).should == "B: String"
    A.new.smurf( :foo ).should == "A: String"
    B.new.smurf( :foo ).should == "B: String"
  end
end
