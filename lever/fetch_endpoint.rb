require_relative '../lib/remote_api/endpoint'

module Lever
  # Endpoint
  class FetchEndpoint < RemoteAPI::Endpoint::Base
    def fetch
      'fetch'
    end
  end
end
