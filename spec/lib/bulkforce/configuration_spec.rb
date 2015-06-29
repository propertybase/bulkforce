#encoding: utf-8
require "spec_helper"

describe Bulkforce::Configuration do
  subject { described_class.new }

  before(:each) { ENV.delete_if {|k| k =~ /^SALESFORCE_/} }

  context "api_version" do
    include_examples "configuration settings", name: :api_version, expected_default: "33.0", env_variable: "SALESFORCE_API_VERSION"
  end

  context "username" do
    include_examples "configuration settings", name: :username, expected_default: nil, env_variable: "SALESFORCE_USERNAME"
  end

  context "password" do
    include_examples "configuration settings", name: :password, expected_default: nil, env_variable: "SALESFORCE_PASSWORD"
  end

  context "security_token" do
    include_examples "configuration settings", name: :security_token, expected_default: nil, env_variable: "SALESFORCE_SECURITY_TOKEN"
  end

  context "host" do
    include_examples "configuration settings", name: :host, expected_default: "login.salesforce.com", env_variable: "SALESFORCE_HOST"
  end

  describe "#to_h" do
    let(:api_version) { "configuration_spec_api_version" }
    let(:username) { "configuration_spec_user" }
    let(:password) { "configuration_spec_password" }
    let(:security_token) { "configuration_spec_security_token" }
    let(:host) { "configuration_spec_host" }

    subject do
      described_class.new.tap do |c|
        c.api_version= api_version
        c.username = username
        c.password = password
        c.security_token = security_token
        c.host = host
      end
    end

    let(:expected_hash) do
      {
        api_version: api_version,
        username: username,
        password: password,
        security_token: security_token,
        host: host,
      }
    end

    it "converts to expected hash" do
      expect(subject.to_h).to eq(expected_hash)
    end

  end
end
