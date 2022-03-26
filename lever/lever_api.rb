require_relative '../lib/remote_api/interface'
require_relative './posting_resource'

module Lever
  # Lever API
  class LeverAPI < RemoteAPI::Interface::Base
    resource :posting
  end
end
