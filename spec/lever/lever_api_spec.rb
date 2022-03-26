require_relative '../../lever/lever_api'

RSpec.describe Lever::LeverAPI do
  subject(:interface) { described_class.new }

  describe 'resources' do
    it 'method responds' do
      expect(interface).to respond_to(:resources)
    end

    it 'responds to []' do
      expect(interface.resources).to respond_to(:[])
    end

    it 'finds the posting resource' do
      expect(interface.resources[:posting]).to be Lever::PostingResource
    end
  end

  describe 'posting resource' do
    it 'method responds' do
      expect(interface).to respond_to(:posting)
    end

    it 'exists' do
      expect(interface.posting).to be Lever::PostingResource
    end

    it 'to be a resource' do
      expect(interface.posting.superclass).to be RemoteAPI::Resource::Base
    end
  end
end
