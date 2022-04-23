require_relative './internal/associated_parts'
require_relative './internal/associated_part_class'

begin
  require 'active_support/inflector'
rescue LoadError
  require 'dry/inflector'
end

module RemoteAPI
  module ParentLayerable
    module ClassMethods
      # Namespace for internal helper classes
      # @api private
      module Internal
        # Provides inflector for transforming strings between various forms
        # @return [ActiveSupport::Inflector | Dry::Inflector] inflector
        def self.inflector
          @inflector ||= if defined?(ActiveSupport::Inflector)
                           ActiveSupport::Inflector
                         else
                           Dry::Inflector.new
                         end
        end
      end
    end
  end
end
