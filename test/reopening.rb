require "#{File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor( :smurf, Integer ) { |x| "A: Integer" }
end

class A
  functor( :smurf, Integer ) { |x| "A: Integer (reopened)" }
end

describe "Functor methods should support reopening" do

  specify "by allowing reopening of a class to override an implementation" do
    A.new.smurf( 5 ).should == "A: Integer (reopened)"
  end

end
