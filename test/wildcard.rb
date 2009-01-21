require "#{File.dirname(__FILE__)}/helpers"

class Wildcard
  include Functor::Method
  functor( :foo, Integer, _whatever ) { |int, whatever| "#{int}: #{whatever}" }
end

describe "A functor" do
  
  it "can use a method beginning with '_' to match anything" do
    c = Wildcard.new
    c.foo( 7, "Smurf").should == "7: Smurf"
  end
  
end