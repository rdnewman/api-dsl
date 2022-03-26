module RemoteAPI
  class RemoteAPIError < RuntimeError; end

  class RemoteAPIConfigurationError < RemoteAPIError; end
end
