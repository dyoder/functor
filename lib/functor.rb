require "#{File.dirname(__FILE__)}/object"
  require 'ruby-debug'

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
      def k.functor( name, *args, &block )
        name = name.to_sym
        ( f = ( functors[ name ] or 
          ( functors[ name ] = Functor.new ) ) ).given( *args, &block )
        define_method( name ) { | *args | instance_exec( *args, &f.match( *args ) ) } 
      end
      def k.functor_with_self( name, *args, &block )
        name = name.to_sym
        ( f = ( functors[ name ] or 
          ( functors[ name ] = Functor.new ) ) ).given( *args, &block )
        define_method( name ) { | *args | instance_exec( *args, &f.match( self, *args ) ) } 
      end
    end
  end
  
  
  def initialize( &block )
    @rules = [] ; yield( self ) if block_given?
  end
  
  def initialize_copy( from )
    @rules = from.instance_eval { @rules.clone }
  end
  
  def given( *pattern, &action )
    @rules << [ pattern, action ]
  end
  
  def call( *args, &block )
    match( *args, &block ).call( *args )
  end
  
  def []( *args, &block )
    call( *args, &block )
  end
  
  def to_proc ; lambda { |*args| self.call( *args ) } ; end
    
  def match( *args, &block )
    args << block if block_given?
    pattern, action = @rules.reverse.find { | p, a | match?( args, p ) }
    action or 
      raise ArgumentError.new( "Argument error: no functor matches the given arguments." )
  end
  
  private
  
  def match?( args, pattern )
    args.zip( pattern ).all? { | arg, rule | pair?( arg, rule ) } if args.length == pattern.length
  end
  
  def pair?( arg, rule )
    ( rule.respond_to? :call and rule.call( arg ) ) or rule === arg
  end
    
end