require "simplecov"
require "coveralls"

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "spec"
end

require "dotenv"
require "bulkforce"
require "webmock/rspec"

Dotenv.load

Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
  config.filter_run_excluding skip: true

  config.include Integration::Operations, type: :integration
  config.before(:context, type: :integration) do
    WebMock.disable!
  end
end

def client
  Bulkforce::Api.new(
    ENV["SALESFORCE_USERNAME"],
    ENV["SALESFORCE_PASSWORD"] + ENV["SALESFORCE_SECURITY_TOKEN"],
  )
end
