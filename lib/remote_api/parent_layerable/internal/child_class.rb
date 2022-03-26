require_relative './children'

module RemoteAPI
  module ParentLayerable
    module ClassMethods
      module Internal
        # Helper class to resolve reference to a member class
        class ChildClass
          class << self
            def infer(reference_symbol, prefix: nil, suffix: nil)
              ChildClass
                .new(reference_symbol, prefix: prefix, suffix: suffix)
                .to_class
            end
          end

          def initialize(reference_symbol, prefix: nil, suffix: nil)
            @original_symbol = reference_symbol
            @prefix = prefix
            @suffix = suffix
          end

          def to_class
            return @to_class if @to_class

            klass_name = inferred_class_name

            klass = Lever.const_get(klass_name)
            unless klass.respond_to?(:new)
              raise RemoteAPIConfigurationError, "#{klass_name} is not a Class"
            end

            @to_class = klass
          end

        private

          attr_reader :prefix, :suffix, :original_symbol

          def inferred_class_name
            return @inferred_class_name if @inferred_class_name

            candidate = Children.inflector.classify(inferred_snake_case_name)
            unless candidate && Lever.const_defined?(candidate)
              raise RemoteAPIConfigurationError, "#{candidate} not defined"
            end

            @inferred_class_name = candidate
          end

          def inferred_snake_case_name
            return @inferred_snake_case_name if @inferred_snake_case_name

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
