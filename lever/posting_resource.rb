require_relative '../lib/remote_api/resource'
require_relative './fetch_endpoint'

module Lever
  # Endpoints for Lever Postings
  class PostingResource < RemoteAPI::Resource::Base
    endpoint :fetch
  end
end
