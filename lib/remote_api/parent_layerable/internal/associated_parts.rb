require_relative './associated_part_class'

module RemoteAPI
  module ParentLayerable
    module ClassMethods
      module Internal
        # Helper container class to support references to associated classes for composition
        class AssociatedParts
          extend Forwardable

          # assumed prefix when inferring associated class names
          attr_reader :prefix
          # assumed suffix when inferring associated class names
          attr_reader :suffix

          # @!method [](key)
          #   @api private
          #   @param key [Symbol]
          #   Returns the associated class for the given key, if found
          #   @see https://ruby-doc.org/core-3.1.1/Hash.html#[]
          #   @return [Class|nil] associated class for key
          def_delegator :parts, :[]

          # @!macro def_delegator_value
          #   @!method $2
          #     @api private
          #     Same as Hash#$2 on collection of associated classes for composition.
          #     @see https://ruby-doc.org/core-3.1.1/Hash.html#$2
          #     @return [Class|nil] associated class for key
          # @!macro def_delegator_pair
          #   @!method $2
          #     @api private
          #     Same as `Hash#$2` on collection of associated classes for composition.
          #     @see https://ruby-doc.org/core-3.1.1/Hash.html#$2
          #     @return [Array|nil] 2-element array of key and its associated class
          # @!macro def_delegator_array
          #   @!method $2
          #     @api private
          #     Same as Hash#$2 on collection of associated classes for composition.
          #     @see https://ruby-doc.org/core-3.1.1/Hash.html#$2
          #     @return [Array]
          # @!macro def_delegator_integer
          #   @!method $2
          #     @api private
          #     Same as Hash#$2 on collection of associated classes for composition.
          #     @see https://ruby-doc.org/core-3.1.1/Hash.html#$2
          #     @return [Integer]
          # @!macro def_delegator_boolean
          #   @!method $2
          #     @api private
          #     Same as Hash#$2 on collection of associated classes for composition.
          #     @see https://ruby-doc.org/core-3.1.1/Hash.html#$2
          #     @return [Boolean]

          # @macro def_delegator_pair
          def_delegator :parts, :assoc
          # @macro def_delegator_boolean
          def_delegator :parts, :empty?
          # @macro def_delegator_value
          def_delegator :parts, :fetch
          # @macro def_delegator_array
          def_delegator :parts, :fetch_values
          # @macro def_delegator_boolean
          def_delegator :parts, :has_key?
          # @macro def_delegator_boolean
          def_delegator :parts, :has_value?
          # @macro def_delegator_boolean
          def_delegator :parts, :include?
          # @macro def_delegator_boolean
          def_delegator :parts, :key?
          # @macro def_delegator_array
          def_delegator :parts, :keys
          # @macro def_delegator_integer
          def_delegator :parts, :length
          # @macro def_delegator_boolean
          def_delegator :parts, :member?
          # @macro def_delegator_pair
          def_delegator :parts, :rassoc
          # @macro def_delegator_integer
          def_delegator :parts, :size
          # @macro def_delegator_boolean
          def_delegator :parts, :value?
          # @macro def_delegator_array
          def_delegator :parts, :values
          # @macro def_delegator_array
          def_delegator :parts, :values_at

          # @param prefix [String] assumed prefix when inferring associated class names
          # @param suffix [String] assumed suffix when inferring associated class names
          def initialize(prefix: nil, suffix: nil)
            @prefix = prefix
            @suffix = suffix
            @parts = {}
          end

          # Tracks what class names have been inferred
          #
          # @param reference_symbol [Symbol|String] name for inferring associated class
          # @raise [RemoteAPIConfigurationError] when reference_symbol is not a String or Symbol
          # @return [true]
          def register(reference_symbol)
            unless reference_symbol.is_a?(Symbol) || reference_symbol.is_a?(String)
              raise RemoteAPIConfigurationError
            end

            klass = AssociatedPartClass.infer(
              reference_symbol.to_sym,
              prefix: prefix,
              suffix: suffix
            )

            @parts.update({ reference_symbol.to_sym => klass })

            true
          end

          # Returns new readonly Hash of inferred associated classes
          #
          # @return [Hash] new readonly Hash of inferred associated classes
          def to_h
            @parts.dup.freeze
          end

        private

          attr_reader :parts
        end
      end
    end
  end
end
