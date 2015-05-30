require 'webmock/rspec'
require 'json'
require_relative '../lib/sparkby'
require_relative 'support/fake_spark_api'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /.*api.particle.io(\/v1)?.*/).to_rack(FakeSparkApi)
  end
end
