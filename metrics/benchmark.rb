require 'rubygems'

$:.unshift "stevedore/lib"
$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'stevedore'
require 'functor'

commit = `git show-ref -s --abbrev HEAD`.chomp

bm = Steve.new "Functor at #{commit}" do
  
  before do
    @fib ||= Functor.new do |f|
      f.given( Integer ) { | n | f.call( n - 1 ) + f.call( n - 2 ) }
      f.given( 0 ) { 0 }
      f.given( 1 ) { 1 }
    end
  end
  
  measure do
    [*0..15].map( &@fib )
  end
  
end

Steve.compare_instances( 10, 10)