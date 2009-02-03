require "#{here = File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor_cache_config :size => 700, :base => 6
  
  functor( :foo, Integer ) { |x| :integer }
  functor( :foo, String )  { |x| :string }
  functor( :foo, Float )   { |x| :float }
  functor( :foo, Symbol )  { |x| :symbol }
  functor( :foo, "one"  )  { |x| :one }
end

class Native
  def foo(x)
    case x
    when Integer then :integer
    when String then :string
    when Float then :float
    when Symbol then :symbol
    when "one" then :one
    else
      raise ArgumentError
    end
  end
end

class OneArg < Steve
  before do
    nums = (1..200).to_a
    alphas = ("a".."gr").to_a
    @args_set = nums + nums.map { |i| i.to_f } + alphas + alphas.map { |i| i.to_sym } + Array.new(200, "one")
    @args = []
    srand(46)
    9000.times { @args << @args_set[rand(@args_set.size)] }
  end
end

OneArg.new "functor method" do
  before_sample do
    @a = A.new    
  end
  measure do
    @args.each { |item| @a.foo item }
  end
  
  after_sample do
    puts A.functor_cache["foo"].map{ |c| c.size }.inspect
  end
end

OneArg.new "native method" do
  before_sample do
    @n = Native.new
  end
  measure do
    @args.each { |item| @n.foo item }
  end
end

OneArg.compare_instances( 4, 96)