require "#{File.dirname(__FILE__)}/object"

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
      
      def k.functor( name, *pattern, &block )
        name = name.to_sym
        f = ( functors[ name ] ||=  Functor.new )
        f.register( *pattern )
        define_method( "functo_#{pattern.hash}", block )
        unless respond_to?( name )
          define_method( name ) do | *args |
            begin
              signature = f.match( *args )
              send "functo_#{signature}", *args
            rescue NoMethodError
              raise ArgumentError.new( "No functor matches the given arguments for method #{name}." )
            end
          end 
        end
      end
      
      def k.functor_with_self( name, *pattern, &block )
        name = name.to_sym
        f = ( functors[ name ] ||=  Functor.new )
        f.register( *pattern )
        define_method( "functo_#{pattern.hash}", block )
        unless respond_to?( name )
          define_method( name ) do | *args |
            begin
              signature = f.match( self, *args )
              send "functo_#{signature}", *args
            rescue NoMethodError
              raise ArgumentError.new( "No functor matches the given arguments for method #{name}." )
            end
          end
        end
      end
      
    end
  end
  
  
  def initialize( &block )
    @rules = [] ; yield( self ) if block_given?
  end
  
  def initialize_copy( from )
    @rules = from.instance_eval { @rules.clone }
  end
  
  def register( *pattern )
    @rules << pattern
  end
  
  def given( *pattern, &action )
    register pattern
    signature = pattern.hash
    name = "functo_#{signature}"
    class << self; self; end.instance_eval do
      define_method( name, action )
    end
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
    pattern = @rules.reverse.find { | p | match?( args, p ) }
    raise ArgumentError.new( "No functor matches the given arguments." ) unless pattern
    pattern.hash
  end
  
  private
  
  def match?( args, pattern )
    args.zip( pattern ).all? { | arg, rule | pair?( arg, rule ) } if args.length == pattern.length
  end
  
  def pair?( arg, rule )
    ( rule.respond_to? :call and rule.call( arg ) ) or rule === arg
  end
    
end