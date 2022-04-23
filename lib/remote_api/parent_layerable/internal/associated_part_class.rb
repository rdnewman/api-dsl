require_relative './associated_parts'

module RemoteAPI
  module ParentLayerable
    module ClassMethods
      module Internal
        # Helper class for resolving references to an associated class for composition
        class AssociatedPartClass
          class << self
            # Infer full name of an associated class based on a given name
            #
            # @param reference_symbol [Symbol|String] unique name on which to base
            #   associated class name
            # @param prefix [String] assumed prefix when inferring associated class names
            # @param suffix [String] assumed suffix when inferring associated class names
            # @raise [RemoteAPIConfigurationError] indicates DSL is not used correctly
            # @return [Class]
            def infer(reference_symbol, prefix: nil, suffix: nil)
              AssociatedPartClass
                .new(reference_symbol, prefix: prefix, suffix: suffix)
                .to_class
            end
          end

          # @param reference_symbol [Symbol|String] unique name on which to base
          #   associated class name
          # @param prefix [String] assumed prefix when inferring associated class names
          # @param suffix [String] assumed suffix when inferring associated class names
          def initialize(reference_symbol, prefix: nil, suffix: nil)
            @original_symbol = reference_symbol
            @prefix = prefix
            @suffix = suffix
          end

          # Returns associated Class based on initial reference_symbol, prefix, and suffix
          #
          # @raise [RemoteAPIConfigurationError] indicates DSL is not used correctly
          # @return [Class]
          def to_class
            return @to_class if defined?(@to_class) && @to_class

            klass_name = inferred_class_name

            klass = Object.const_get(klass_name)
            unless klass.respond_to?(:new)
              raise RemoteAPIConfigurationError, "#{klass_name} is not a Class"
            end

            @to_class = klass
          end

        private

          attr_reader :prefix, :suffix, :original_symbol

          def inferred_class_name
            return @inferred_class_name if defined?(@inferred_class_name) && @inferred_class_name

            candidate = Internal.inflector.classify(inferred_snake_case_name)
            unless candidate && Object.const_defined?(candidate)
              raise RemoteAPIConfigurationError, "#{candidate} not defined"
            end

            @inferred_class_name = candidate
          end

          def inferred_snake_case_name
            if defined?(@inferred_snake_case_name) && @inferred_snake_case_name
              return @inferred_snake_case_name
            end

            raise RemoteAPIConfigurationError unless valid_name?

            raw_name = original_symbol.to_s
            raw_name = "#{prefix}_#{raw_name}" if prefix
            raw_name = "#{raw_name}_#{suffix}" if suffix

            @inferred_snake_case_name = raw_name
          end

          def valid_name?
            valid_name = true
            valid_name &&= !(prefix && original_symbol.to_s.start_with?("#{prefix}_"))
            valid_name &&= !(suffix && original_symbol.to_s.end_with?("_#{suffix}"))

            valid_name
          end
        end
      end
    end
  end
end
