require_relative './parent_layerable/parent_layerable'

module RemoteAPI
  module Interface
    # Base class for quickly defining an API interface of resource endpoints
    class Base
      include ParentLayerable

      class << self
        def inherited(subclass)
          super
          children_as(:resource)
        end

        def resource(klass_symbol)
          add_child(klass_symbol)
        end
      end

      def connection(endpoint_url)
        url = "#{base_url}#{endpoint_url}"
        Excon.new(url, user: key) # TODO: how solve authentication more generally?
      end

    protected

      def headers
        raise NotImplementedError
      end

      def key
        raise NotImplementedError
      end

      def base_url
        raise NotImplementedError
      end
    end
  end
end
