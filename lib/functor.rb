require "#{File.dirname(__FILE__)}/object"
require 'rubygems'
require 'metaid'

class Functor
  
  class NoMatch < ArgumentError
    
  end
  
  def self.cache_config(options={})
    (@cache_config ||= { :size => 10_000, :base => 10 }).merge!(options)
  end
  
  module Method
    
    def self.included( k )
            
      def k.functor_cache
        @functor_cache ||= Hash.new { |hash, key| hash[key] = [ {},{},{},{} ] }
      end
      
      def k.functor_cache_config(options={})
        @functor_cache_config = ( @functor_cache_config || Functor.cache_config ).merge(options)
      end
      
      def k.functor( name, *pattern, &action )
        _functor( name, false, *pattern, &action)
      end
      
      def k.functor_with_self( name, *pattern, &action )
        _functor( name, true, *pattern, &action)
      end
      
      def k.method_missing(name, *args)
        args.empty? && name.to_s =~ /^_/  ?  lambda { true}  :  super
      end
      
      private
      
      def k._functor( name, with_self=false, *pattern, &action)
        name = name.to_s
        mc = functor_cache[name]  # grab the cache tiers for The Method
        cache_size, cache_base = functor_cache_config[:size], functor_cache_config[:base]
        c0_size, c1_size, c2_size, c3_size = cache_size * 4, cache_size * 3, cache_size * 2, cache_size
        c1_thresh,c2_thresh,c3_thresh = cache_base.to_i, (cache_base ** 2).to_i, (cache_base ** 3).to_i
        old_method = instance_method(name) if instance_methods.include?( name ) # grab The Method's current incarnation        
        define_method( name, action ) # redefine The Method
        newest = instance_method(name) # grab newly redefined The Method
        
        # Recursively redefine The Method using the newest and previous incarnations
        define_method( name ) do | *args |
          match_args = with_self ? [self] + args : args
          sig = match_args.hash
          if meth = mc[3][sig]  # check caches from top down
            meth[0].bind(self).call(*args)
          elsif meth = mc[2][sig]
            meth[1] += 1  # increment hit count
            mc[3][sig] = mc[2].delete(sig) if meth[1] > c3_thresh # promote sig if it has enough hits
            (mc[0], mc[1], mc[2], mc[3] = mc[1], mc[2], mc[3], {}) if mc[3].size >= c3_size # cascade if c3 is full
            meth[0].bind(self).call(*args)
          elsif meth = mc[1][sig]
            meth[1] += 1
            mc[2][sig] = mc[1].delete(sig) if meth[1] > c2_thresh
            mc[0], mc[1], mc[2] = mc[1], mc[2], {} if mc[2].size >= c2_size
            meth[0].bind(self).call(*args)
          elsif meth = mc[0][sig]
            meth[1] += 1
            mc[1][sig] = mc[0].delete(sig) if meth[1] > c1_thresh 
            mc[0], mc[1] = mc[1], {} if mc[1].size >= c1_size
            meth[0].bind(self).call(*args)
          elsif Functor.match?(match_args, pattern) # not cached?  Try newest meth/pat.
            (mc[0], mc[1], mc[2], mc[3] = mc[1], mc[2], mc[3], {})  if mc[3].size >= c3_size
            mc[3][sig] = [newest, 0]  # methods are cached as [ method, counter ]
            newest.bind(self).call(*args)
          elsif old_method  # or call the previous incarnation of The Method
            old_method.bind(self).call(*args)
          else  # and if there are no older incarnations, whine about it
            raise NoMatch.new( "No functor matches the given arguments for method :#{name}." )
          end
        end 
      end
      
    end
  end
  
  # Stuff for using standalone instances of Functor
  
  # When creating a functor instance, use given within the block to add actions
  def initialize( &block )
    class << self; include Functor::Method; end
    yield( self ) if block_given?
  end
  
  def given( *pattern, &action )
    class << self; self; end._functor( "call", false, *pattern, &action)
  end
  
  def []( *args, &block )
    call( *args, &block )
  end
  
  def to_proc ; lambda { |*args| call( *args ) } ; end
    
  def self.match?( args, pattern )
    args.all? do |arg|
      pat = pattern[args.index(arg)]; pat === arg || ( pat.respond_to?(:call) && pat.call(arg))
    end if args.length == pattern.length
  end
    
end