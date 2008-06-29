require 'lib/object'

class Functor
  
  module Method
    def self.included( k )
      def k.functors ; @__functors ||= {} ; end
      def k.functor( name, *args, &block )
        unless functors[ name ]
          functors[ name ] = Functor.new
          klass = self.name ; module_eval <<-CODE
            def #{name}( *args, &block ) 
              begin
                rval = #{klass}.functors[ :#{name} ].apply( self, *args, &block ) 
              rescue ArgumentError => e
                begin
                  super
                rescue NoMethodError => f
                  raise e
                end
              end
              if rval.is_a? Continuation
                super ; rval.call
              else
                rval
              end
            end
          CODE
        end
        functors[ name ].given( *args, &block )
      end
    end
  end
  
  def initialize( &block ) 
    @rules = [] ; instance_eval( &block ) if block_given?
  end
  
  def given( *pattern, &action )
    @rules.delete_if { |p,a| p == pattern }
    @rules << [ pattern, action ]
  end
  
  def apply( object, *args, &block )
    object.instance_exec( *args, &match( *args, &block ) )
  end
  
  def call( *args, &block )
    args.push( block ) if block_given?
    match( *args, &block ).call( *args )
  end
  
  def to_proc ; lambda { |*args| self.call( *args ) } ; end
  
  private
  
  def match( *args, &block )
    args.push( block ) if block_given? 
    pattern, action = @rules.find { | pattern, action | match?( args, pattern ) }
    raise ArgumentError.new( "argument mismatch for argument(s): #{ args.map { |arg| arg.inspect }.join(', ') }." ) unless action
    return action
  end
  
  def match?( args, pattern )
    args.zip( pattern ).all? { | arg, rule | pair?( arg, rule ) } if args.length == pattern.length
  end
  
  def pair?( arg, rule )
    ( rule.is_a?( Proc ) and rule.call( arg ) ) or rule === arg or rule == arg
  end
  
end