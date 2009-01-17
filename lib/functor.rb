require "#{File.dirname(__FILE__)}/object"
require 'rubygems'
require 'metaid'

class Functor
  
  module Method
    
    def functor_cache
      self.class.functor_cache
    end
    
    def self.included( k )
      
      def k.functor_cache
        @functor_cache ||= {}
      end
      
      def k.functor_cache_size(val=nil)
        @functor_cache_size = val if val
      end
      
      def k.functor( name, *pattern, &action )
        name = name.to_s
        cache = (functor_cache[name] ||= {})
        cache_size = functor_cache_size
        old = instance_method(name) if instance_methods.include?( name )           
        define_method( name, action )
        newest = instance_method(name)
        define_method( name ) do | *args |
          signature = args.hash
          if meth = cache[signature]
            meth.bind(self).call(*args)
          elsif Functor.match?(args, pattern)
            cache = {} if cache_size && cache.size > cache_size
            cache[signature] = newest
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
        cache = (functor_cache[name] ||= {})
        cache_size = functor_cache_size
        old = instance_method(name) if instance_methods.include?( name )           
        define_method( name, action )
        newest = instance_method(name)
        define_method( name ) do | *args |
          s_args = [self] + args
          signature = (s_args).hash
          if meth = cache[signature]
            meth.bind(self).call(*args)
          elsif Functor.match?(s_args, pattern)
            cache = {} if cache_size && cache.size > cache_size
            cache[signature] = newest
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