RSpec.describe RemoteAPI::Resource::Base do
  let(:klass) do
    Class.new(described_class) do
      endpoint :test
    end
  end
  let(:object) { klass.new }

  before do
    stub_const('TestEndpoint', Class.new)
  end

  it '#test returns TestEndpoint' do
    expect(object.test).to eq TestEndpoint
  end

  it '#endpoints[:test] returns TestEndpoint' do
    expect(object.endpoints[:test]).to eq TestEndpoint
  end
end
