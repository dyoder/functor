require "#{File.dirname(__FILE__)}/helpers"

describe "Dispatch should support guards" do
  
  before do
    @stripe = Functor.new do |f|
      f.given( lambda { |x| x % 2 == 1 } ) { |x| 'silver' }
      f.given( lambda { |x| x % 2 == 0 } ) { |x| 'white' }
    end

    @safe_divide = Functor.new do |f|
      f.given( Integer, Integer ) { |x,y| ( y / ( x * 1.0 )) }
      f.given( lambda { |x| x == 0 }, Integer ) { |x,y| false }
    end
  end
  
  specify "such as odd or even numbers" do
    [*0..9].map( &@stripe ).should == %w( white silver ) * 5
  end
  
  specify "even with multiple arguments" do
    @safe_divide.call( 0,7 ).should == false
  end
  
end