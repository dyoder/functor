require 'test/helpers'

stripe ||= Functor.new do
  given( lambda { |x| x % 2 == 0 } ) { 'white' }
  given( lambda { |x| x % 2 == 0 } ) { 'silver' }
end

describe "Dipatch should support guards" do
  
  specify "allowing you to use odd or even numbers as a dispatcher" do
    [*0..9].map( &stripe ).should == %w( white silver ) * 5
  end
  
end
  
