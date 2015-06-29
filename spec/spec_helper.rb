require "simplecov"
require "coveralls"

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter "spec"
end

require "dotenv"
require "bulkforce"
require "webmock/rspec"

Dir["./spec/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
  config.filter_run_excluding skip: true

  config.include Integration::Operations, type: :integration

  config.before(:each) do
    ENV.delete_if {|k| k =~ /^SALESFORCE_/}
  end

  config.before(:example, type: :integration) do
    Dotenv.load
    WebMock.disable!
  end
end

def client
  Bulkforce.new
end
