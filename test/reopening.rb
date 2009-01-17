require "#{File.dirname(__FILE__)}/helpers"

class Reopening
  include Functor::Method
  functor( :foo, Integer ) { |x| 1 }
end

class Reopening
  functor( :foo, Integer ) { |x| 2 }
end

describe "Functor methods should support reopening" do

  specify "by allowing reopening of a class to override an implementation" do
    Reopening.new.foo( 5 ).should == 2
  end

end
