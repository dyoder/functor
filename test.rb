load 'lib/functor.rb'
class A
  include Functor::Method
  functor( :foo, Integer ) { |x| [ A, Integer ] }
  functor( :foo, String ) { |s| [ A, String ] }
  functor( :foo, Float ) { |h| [ A, Float ] }
end

class B < A
  functor( :foo, String ) { |s| [ B, String ] }
  functor( :foo, Float ) { |f| [ B, *A.functors[:foo].apply( self, f ) ] }
end

a = A.new ; b = B.new
puts a.foo( 7 ).inspect
puts b.foo( 'tentacles' ).inspect

fib ||= Functor.new do
  given( 0 ) { 0 }
  given( 1 ) { 1 }
  given( Integer ) { | n | self.call( n - 1 ) + self.call( n - 2 ) }
end

puts fib[ 7 ]