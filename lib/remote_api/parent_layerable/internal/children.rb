require_relative './child_class'

module RemoteAPI
  module ParentLayerable
    module ClassMethods
      module Internal
        # Helper container class to support references to member classes
        class Children
          class << self
            def inflector
              @inflector ||= Dry::Inflector.new
            end
          end

          extend Forwardable

          attr_reader :prefix, :suffix

          def_delegators :children, :[], :fetch, :assoc, :rassoc
          def_delegators :children, :keys, :values, :fetch_values, :values_at
          def_delegators :children, :has_key?, :key?, :has_value?, :value?, :member?, :include?
          def_delegators :children, :size, :length, :empty?

          def initialize(prefix: nil, suffix: nil)
            @prefix = prefix
            @suffix = suffix
            @children = {}
          end

          def register(reference_symbol)
            unless reference_symbol.is_a?(Symbol) || reference_symbol.is_a?(String)
              raise RemoteAPIConfigurationError
            end

            klass = ChildClass.infer(reference_symbol.to_sym, prefix: prefix, suffix: suffix)

            @children.update({ reference_symbol => klass })
          end

        private

          attr_reader :children
        end
      end
    end
  end
end
