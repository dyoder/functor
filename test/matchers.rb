require "#{File.dirname(__FILE__)}/helpers"

class Matchers
  include Functor::Method
  functor( :foo, Integer ) { |a| "===" }
  functor( :foo, 1 ) { |a| "==" }
  functor( :foo, lambda { |a| a == "boo" } ) { |v| "Lambda: #{v}" }
end

describe "Functors match" do

  specify "using ==" do
    Matchers.new.foo( 1 ).should == "=="
  end
  
  specify "using ===" do
    Matchers.new.foo( 2 ).should == "==="
  end

  specify "using #call" do
    Matchers.new.foo( "boo" ).should == "Lambda: boo"
  end

end
