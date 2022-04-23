require_relative './parent_layerable/parent_layerable'

module RemoteAPI
  # Logically groups API endpoints together for a common resource
  # (e.g., endpoints for working with a user)
  module Resource
    # Base class for quickly defining API resources of endpoints
    class Base
      include ParentLayerable

      # @!macro [attach] endpoint
      #   @macro compose $0
      comprised_of :endpoints
    end
  end
end
