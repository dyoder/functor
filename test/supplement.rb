require "#{File.dirname(__FILE__)}/helpers"

class Additive
  include Functor::Method
  
  def foo(*args)
    args.reverse
  end
  
  functor( :foo, Integer ) { |x| 1 }
end

describe "A Functor method" do

  specify "supplements, rather than obliterating, an existing method" do
    Additive.new.foo( 5 ).should == 1
    Additive.new.foo( :a, :b).should == [ :b, :a ]
  end

end