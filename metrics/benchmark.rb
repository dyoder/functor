require 'rubygems'

$:.unshift "#{here = File.dirname(__FILE__)}/stevedore/lib"
$:.unshift "#{here}/../lib"
require 'stevedore'
require 'functor'


class FuncFib < Steve
  
  subject "Fibonacci using Functor"
  
  # power 0.8
  # sig_level 0.05
  delta 0.01
  
  before do
    @fib ||= Functor.new do |f|
      f.given( Integer ) { | n | f.call( n - 1 ) + f.call( n - 2 ) }
      f.given( 0 ) { 0 }
      f.given( 1 ) { 1 }
    end
  end
end

fib_8 = FuncFib.new "f(8)" do  
  measure do
    64.times { @fib.call(8) }
  end
end

fib_16 = FuncFib.new "f(16)" do  
  measure do
    2.times { @fib.call(16)  }
  end
end

# FuncFib.recommend_test_size( 8, 16)
FuncFib.compare_instances( 8, 128)