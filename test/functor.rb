require "#{File.dirname(__FILE__)}/helpers"

class Repeater
  attr_accessor :times
  include Functor::Method
  functor( :repeat, Integer ) { |x| x * @times }
  functor( :repeat, String, String ) { |s,t| [].fill( s, 0, @times ).join( t ) }
end

describe "Dispatch on instance method should" do
  
  before do
    @r = Repeater.new
    @r.times = 5
  end
  
  specify "invoke different methods with object scope based on arguments" do
    @r.repeat( 5 ).should == 25
  end
  
  specify "should handle multiple arguments" do
    @r.repeat( '-', '.' ).should == '-.-.-.-.-'
  end
  
  specify "should raise an exception if there is no matching value" do
    lambda { @r.repeat( 7.3) }.should.raise(ArgumentError)
  end
  
end
  
  