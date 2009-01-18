require "#{File.dirname(__FILE__)}/object"
require 'rubygems'
require 'metaid'

class Functor
  
  module Method
    
    def functor_cache
      self.class.functor_cache
    end
    
    def self.included( k )
      
      def k.functor_cache; @functor_cache ||= [{},{},{},{}]; end
      
      def k.functor_cache_config(options={})
        @functor_cache_size = options[:size] if options[:size]
        @functor_cache_base = options[:base] if options[:base]
      end
      
      def k.functor_cache_size(val=nil)
        @functor_cache_size ||= val
      end
      
      
      def k.functor_cache_base(val=nil)
        @functor_cache_base || @functor_cache_base = ( val || 16 )
      end
      
      def k.functor_cache_0; functor_cache[0]; end
      def k.functor_cache_1; functor_cache[1]; end
      def k.functor_cache_2; functor_cache[2]; end
      def k.functor_cache_3; functor_cache[3]; end
      
      def k.functor( name, *pattern, &action )
        _functor( name, false, *pattern, &action)
      end
      
      def k.functor_with_self( name, *pattern, &action )
        _functor( name, true, *pattern, &action)
      end
      
      private
      
      def k._functor( name, with_self=false, *pattern, &action)
        name = name.to_s
        c0,c1,c2,c3 = (0..3).map { |i| functor_cache[i][name] ||= {} }
        cache_size, cache_base = functor_cache_size, functor_cache_base
        c1_thresh,c2_thresh,c3_thresh = cache_base.to_i, (cache_base ** 2).to_i, (cache_base ** 3).to_i
        old = instance_method(name) if instance_methods.include?( name )           
        define_method( name, action )
        newest = instance_method(name)
        define_method( name ) do | *args |
          match_args = with_self ? [self] + args : args
          signature = match_args.hash
          if meth = c3[signature]
            meth.first.bind(self).call(*args)
          elsif meth = c2[signature]
            # when c3 fills up, shift its contents down to c2, and so forth
            c0, c1, c2, c3 = c1, c2, c3, {} if cache_size && c3.size >= cache_size
            count = meth[-1]
            (c3[signature] = meth && c2.delete(signature)) if count > c3_thresh
            meth[-1] += 1
            meth.first.bind(self).call(*args)
          elsif meth = c1[signature]
            c0, c1, c2 = c1, c2, {} if cache_size && c2.size >= cache_size
            count = meth[-1]
            (c2[signature] = meth && c1.delete(signature)) if count > c2_thresh
            meth[-1] += 1
            meth.first.bind(self).call(*args)
          elsif meth = c0[signature]
            c0, c1 = c1, {} if cache_size && c1.size >= cache_size
            count = meth[-1]
            (c1[signature] = meth && c0.delete(signature)) if count > c1_thresh 
            meth[-1] += 1
            meth.first.bind(self).call(*args)
          elsif Functor.match?(match_args, pattern)
            c0 = {} if cache_size && c0.size >= cache_size
            c0[signature] = [newest, 0]
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
  
  # Stuff for using standalone instances of Functor
  
  # When creating a functor instance, use given within the block to add actions
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