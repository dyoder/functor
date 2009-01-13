require "#{here = File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor( :foo, Integer, String ) { |x| :integer }
  functor( :foo, String, Float )  { |x| :string }
  functor( :foo, Float, Symbol )   { |x| :float }
  functor( :foo, Symbol, "one" )  { |x| :symbol }
  functor( :foo, "one", false  )  { |x| :one }
end

class B
  def foo(x)
    case x
    when Integer
    when String
    when Float
    when Symbol
    when "one"
    else
      raise ArgumentError
    end
  end
end