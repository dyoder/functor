require "#{File.dirname(__FILE__)}/helpers"

fib ||= Functor.new do |f|
  f.given( Integer ) { | n | f.call( n - 1 ) + f.call( n - 2 ) }
  f.given( 0 ) { |x| 0 }
  f.given( 1 ) { |x| 1 }
end

describe "Dispatch on a functor object should" do
  
  specify "be able to implement the Fibonacci function" do
    [*0..10].map( &fib ).should == [ 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55 ]
  end
  
end
  
