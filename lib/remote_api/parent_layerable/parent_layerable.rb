require_relative './internal'
require_relative './../error'

module RemoteAPI
  # Supports layering for object composition in DSL
  module ParentLayerable
    def self.included(base)
      base.extend ClassMethods
    end

    # Class methods for extension
    module ClassMethods
      def inherited(subclass)
        @parent_layerable_class = subclass
        super
      end

      def children_as(child_type_symbol)
        unless child_type_symbol.is_a?(Symbol) || child_type_symbol.is_a?(String)
          raise RemoteAPIConfigurationError
        end

        # Define the collection of children
        collection = Internal::Children.new(suffix: child_type_symbol.to_s)

        # DSL for defining specific children
        define_method(child_type_symbol) { |klass_symbol| add_child(klass_symbol) }

        # DSL for retrieving any child or working with the children
        method_name = Internal::Children.inflector.pluralize(child_type_symbol)
        define_method(method_name) { collection }

        # Record the container object into the subject class
        @parent_layerable_class.instance_variable_set(:@children, collection)
      end

      def add_child(reference_symbol)
        raise RemoteAPIConfigurationError unless children?

        children.register(reference_symbol)

        define_method(reference_symbol) { self.class.children[reference_symbol] }
      end

      def children
        @children ||= @parent_layerable_class.instance_variable_get(:@children)
      end

      def children?
        !children.nil?
      end
    end
  end
end
