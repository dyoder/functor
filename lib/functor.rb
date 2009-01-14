require "#{File.dirname(__FILE__)}/object"
require 'rubygems'
require 'metaid'

class Functor
  
  module Method
    
    def self.included( k )
      
      def k.functor( name, *pattern, &action )
        name = name.to_s
        old = instance_method(name) if instance_methods.include?( name )           
        define_method( name, action )
        newest = instance_method(name)
        define_method( name ) do | *args |
          if Functor.match?(args, pattern)
            newest.bind(self).call(*args)
          elsif old
            old.bind(self).call(*args)
          else
            raise ArgumentError.new( "No functor matches the given arguments for method :#{name}." )
          end
        end 
      end
      
      def k.functor_with_self( name, *pattern, &action )
        name = name.to_s
        old = instance_method(name) if instance_methods.include?( name )           
        define_method( name, action )
        newest = instance_method(name)
        define_method( name ) do | *args |
          if Functor.match?([self] + args, pattern)
            newest.bind(self).call(*args)
          elsif old
            old.bind(self).call(*args)
          else
            raise ArgumentError.new( "No functor matches the given arguments for method :#{name}." )
          end
        end
      end
      
    end
  end
  
  
  def initialize( &block )
    yield( self ) if block_given?
  end
  
  def given( *pattern, &action )
    name = "call"
    old = method(name) if methods.include?( name )
    class << self; self; end.instance_eval do
      define_method( name, action )
    end
    newest = method(name)
    class << self; self; end.instance_eval do
      
      define_method( name ) do | *args |
        if Functor.match?(args, pattern)
          newest.call(*args)
        elsif old
          old.call(*args)
        else
          raise ArgumentError.new( "No functor matches the given arguments for method :#{name}." )
        end
      end
      
    end
  end
  
  def []( *args, &block )
    call( *args, &block )
  end
  
  def to_proc ; lambda { |*args| self.call( *args ) } ; end
    
  def self.match?( args, pattern )
    args.all? do |a|
      p = pattern[args.index(a)]; p === a || ( p.respond_to?(:call) && p.call(a))
    end if args.length == pattern.length
  end
    
end