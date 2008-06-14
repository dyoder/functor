require "#{File.dirname(__FILE__)}/helpers"

fib ||= Functor.new do
  given( 0 ) { 0 }
  given( 1 ) { 1 }
  given( lambda { |v| v > 1 } ) { |n| self.call( n - 1 ) + self.call( n - 2 ) }
end

describe "Dispatch on a functor object should" do
  
  specify "be able to implement the Fibonacci function" do
    [*0..10].map( &fib ).should == [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
  end
  
end
  
