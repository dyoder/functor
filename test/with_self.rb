require "#{File.dirname(__FILE__)}/helpers"

class A
  attr_accessor :bar
  include Functor::Method
  def initialize( x ) ; @bar = x ; end
  functor_with_self( :foo, self, Integer ) { |x| x }
  functor_with_self( :foo, lambda{ |x| x.bar == true }, Integer ) { |s| 'bar' }
end

describe "Functor methods should support allow matching on self" do
  
  specify "by allowing functor_with_self to provide a guard on self" do
    A.new( true ).foo( 5 ).should == 'bar'
  end
  
  specify "or by simply providing self as an argument" do
    A.new( false ).foo( 5 ).should == 5
  end

end
