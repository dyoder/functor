require "#{File.dirname(__FILE__)}/object"
require 'rubygems'
require 'metaid'

class Functor
  
  module Method
    
    def self.copy_functors( functors )
      r = {} ; functors.each do | name, functor |
        r[ name ] = functor.clone
      end
      return r
    end
    
    def self.included( k )
      
      def k.functors
        @__functors ||= superclass.respond_to?( :functors ) ? 
          Functor::Method.copy_functors( superclass.functors ) : {}
      end
      
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
    @patterns = []
    yield( self ) if block_given?
  end
  
  def initialize_copy( from )
    @patterns, @associations = from.instance_eval { [@patterns.clone, @associations.clone] }
  end
  
  def given( *pattern, &action )
    register pattern
    name = "functo_#{pattern.hash}"
    class << self; self; end.instance_eval do
      define_method( name, action )
    end
  end
  
  def register( pattern )
    @patterns.unshift pattern
  end
  
  def call( *args, &block )
    signature = match( *args, &block )
    send "functo_#{signature}", *args
  end
  
  def []( *args, &block )
    call( *args, &block )
  end
  
  def to_proc ; lambda { |*args| self.call( *args ) } ; end
    
  def match( *args, &block )
    args << block if block_given?
    pattern = @patterns.find { | p | match?( args, p ) }
    raise ArgumentError.new( "No functor matches the given arguments." ) unless pattern
  end
  
  
  def self.match?( args, pattern )
    args.zip( pattern ).all? { | arg, pat | pair?( arg, pat ) } if args.length == pattern.length
  end
  
  def self.pair?( arg, pat )
    ( pat.respond_to? :call and pat.call( arg ) ) or pat === arg
  end
  
  def match?( args, pattern )
    args.zip( pattern ).all? { | arg, pat | pair?( arg, pat ) } if args.length == pattern.length
  end
  
  def pair?( arg, pat )
    ( pat.respond_to? :call and pat.call( arg ) ) or pat === arg
  end
    
end