require "#{here = File.dirname(__FILE__)}/helpers"

class A
  include Functor::Method
  functor( :foo, Integer, String ) { |x| :int_string }
  functor( :foo, Integer, Float ) { |x| :int_float }
  functor( :foo, String, Float )  { |x| :string_float }
  functor( :foo, String, Symbol )  { |x| :string_symbol }
  functor( :foo, Float, Symbol )   { |x| :float_symbol }
  functor( :foo, Float, String )   { |x| :float_string }
  functor( :foo, Symbol, "one" )  { |x| :symbol_one }
  functor( :foo, "one", false  )  { |x| :one_false }
end

class B
  def foo(x,y)
    case x
    when Integer
      case y
      when String
        :int_string
      when Float
        :int_float
      end
    when String
      case y
      when Float
        :string_float
      when Symbol
        :string_symbol
      end
    when Float
    when Symbol
    when "one"
    else
      raise ArgumentError
    end
  end
end