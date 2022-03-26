require_relative './parent_layerable/parent_layerable'

module RemoteAPI
  module Resource
    # Base class for quickly defining API resources of endpoints
    class Base
      include ParentLayerable

      class << self
        def inherited(subclass)
          super
          children_as(:endpoint)
        end

        def endpoint(klass_symbol)
          add_child(klass_symbol)
        end
      end
    end
  end
end
