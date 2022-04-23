require_relative './parent_layerable/parent_layerable'

module RemoteAPI
  # Root level for a given API at a common remote URL
  module Interface
    # Base class for quickly defining an API interface of resource endpoints
    class Base
      include ParentLayerable

      # @!macro [attach] resource
      #   @macro compose $0
      comprised_of :resources

      # Provides connection to remote API for an endpoint
      #
      # @param endpoint_url [String] part of URL specific to an endpoint
      # @return [Excon::Connection]
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
