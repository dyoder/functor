require 'lib/object'

class Functor
  
  def self.precedence
    lambda do |pattern|
      case pattern ; when Class then 0 ; when Proc then 1 ; when Regexp then 2 ; else 3 ; end
    end
  end

  module Method
    def self.included( k )
      def k.functor( name, *args, &block )
        functors = module_eval { @__functors ||= {} }
        unless functors[ name ]
          functors[ name ] = Functor.new
          klass = self.name
          module_eval <<-CODE
            def #{name}( *args, &block ) 
              begin
                functors = #{klass}.module_eval { @__functors }
                functors[ :#{name} ].bind( self ).call( *args, &block ) 
              rescue ArgumentError => e
                begin
                  super
                rescue NoMethodError => f
                  raise e
                end
              end
            end
          CODE
        end
        functors[ name ].given( *args, &block )
      end
    end
  end
  
  def initialize( &block ) @patterns = {}; instance_eval( &block ) if block_given? ; end
  
  def given( *pattern, &action ) ; @patterns[ pattern ] = action ; end
  
  def bind( object ) ; @object = object ; self ; end
  
  def call( *args, &block )
    args.push( block ) if block_given?
    candidates = @patterns.keys.select { |pattern| match?( args, pattern ) }
    raise ArgumentError.new( "argument mismatch for argument(s): #{args.inspect}." ) if candidates.empty?
    action = @patterns[ candidates.sort( &Functor.precedence ).first ]
    @object ? @object.instance_exec( *args, &action ) : action.call( *args )
  end
  
  def to_proc
    lambda { |*args| self.call(*args) }
  end
  
  private
  
  def match?( args, pattern )
    pattern.zip(args).all? { |x,y| x === y or x == y or 
        ( x.respond_to?(:call) && x.call( y ) ) } if pattern.length == args.length
  end
  
end