require 'rubygems'

$:.unshift "#{here = File.dirname(__FILE__)}/stevedore/lib"
$:.unshift "#{here}/../lib"
require 'stevedore'
require 'functor'


class FuncFib < Steve
  
  subject "Fibonacci using Functor"
  before do
    @fib ||= Functor.new do |f|
      f.given( Integer ) { | n | f.call( n - 1 ) + f.call( n - 2 ) }
      f.given( 0 ) { 0 }
      f.given( 1 ) { 1 }
    end
  end
end

fib_13 = FuncFib.new "f(10)" do  
  measure do
    100.times { @fib.call(10) }
  end
end

fib_15 = FuncFib.new "f(20)" do  
  measure { @fib.call(20)  }
end

FuncFib.compare_instances( 4, 8)