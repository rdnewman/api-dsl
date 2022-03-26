require_relative './internal/children'
require_relative './internal/child_class'

module RemoteAPI
  module ParentLayerable
    module ClassMethods
      # Namespace for internal helper classes
      # @api private
      module Internal
      end
    end
  end
end
