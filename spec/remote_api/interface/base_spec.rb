RSpec.describe RemoteAPI::Interface::Base do
  let(:klass) do
    Class.new(described_class) do
      resource :test
    end
  end
  let(:object) { klass.new }

  before do
    stub_const('TestResource', Class.new)
  end

  it '#test returns TestResource' do
    expect(object.test).to eq TestResource
  end

  it '#resources[:test] returns TestResource' do
    expect(object.resources[:test]).to eq TestResource
  end
end
