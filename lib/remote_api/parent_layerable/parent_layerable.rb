require_relative './internal'
require_relative './../error'

module RemoteAPI
  # Supports layering for object composition in DSL
  # @api private
  module ParentLayerable
    def self.included(base)
      base.extend ClassMethods
    end

    # Class methods for extension
    module ClassMethods
      # Specify associated names for inferring composed classes to support DSL schema
      #
      # @example To allow the DSL of +resource: somename+ in the inherited class, specify
      #   comprised_of :resources
      #
      # @param associated_type [Symbol|String] type of composed class that may be specified by DSL
      # @return [nil]
      # @!macro new compose
      #   @!method $1(klass_symbol)
      #     Specifies that the given klass_symbol refers to $1 class
      # #     @param associated_type [Symbol]
      #     @return [nil]
      #   @!method $1
      #     List all $1
      #     @return [Hash]
      def comprised_of(associated_type)
        unless associated_type.is_a?(Symbol) || associated_type.is_a?(String)
          raise RemoteAPIConfigurationError
        end

        singular = Internal.inflector.singularize(associated_type)
        plural = Internal.inflector.pluralize(associated_type)

        # Define the collection of associated part classes to be composed
        collection = Internal::AssociatedParts.new(suffix: singular)

        # DSL for composing associated classes
        #
        define_singleton_method(singular) do |klass_symbol|
          collection.register(klass_symbol) || (raise RemoteAPIConfigurationError)

          define_method(klass_symbol) { collection[klass_symbol] }

          nil
        end

        # DSL for retrieving any associate class or working with the set
        define_method(plural) { collection.to_h }

        nil
      end
    end
  end
end
