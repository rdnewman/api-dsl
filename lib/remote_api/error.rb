module RemoteAPI
  # Base class for all custom RemoteAPI errors
  class RemoteAPIError < RuntimeError; end

  # Error in setup or use of the RemoteAPI DSL
  class RemoteAPIConfigurationError < RemoteAPIError; end
end
