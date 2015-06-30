#encoding: utf-8
require "spec_helper"

describe Bulkforce::Configuration do
  subject { described_class.new }

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

  context "session_id" do
    include_examples "configuration settings", name: :session_id, expected_default: nil, env_variable: "SALESFORCE_SESSION_ID"
  end

  context "instance" do
    include_examples "configuration settings", name: :instance, expected_default: nil, env_variable: "SALESFORCE_INSTANCE"
  end

  context "client_id" do
    include_examples "configuration settings", name: :client_id, expected_default: nil, env_variable: "SALESFORCE_CLIENT_ID"
  end

  context "client_secret" do
    include_examples "configuration settings", name: :client_secret, expected_default: nil, env_variable: "SALESFORCE_CLIENT_SECRET"
  end

  context "refresh_token" do
    include_examples "configuration settings", name: :refresh_token, expected_default: nil, env_variable: "SALESFORCE_REFRESH_TOKEN"
  end

  describe "#to_h" do
    let(:api_version) { "configuration_spec_api_version" }
    let(:username) { "configuration_spec_user" }
    let(:password) { "configuration_spec_password" }
    let(:security_token) { "configuration_spec_security_token" }
    let(:host) { "configuration_spec_host" }
    let(:session_id) { "00Dx0000000BV7z!AR8AQP0jITN80ESEsj5EbaZTFG0RNBaT1cyWk7TrqoDjoNIWQ2ME_sTZzBjfmOE6zMHq6y8PIW4eWze9JksNEkWUl.Cju7m4" }
    let(:instance) { "eu2" }
    let(:client_id) { "3MVG9lKcPoNINVBIPJjdw1J9LLM82HnFVVX19KY1uA5mu0QqEWhqKpoW3svG3XHrXDiCQjK1mdgAvhCscA9GE&client_secret=1955279925675241571" }
    let(:client_secret) { "3MVG9lKcPoNINVBIPJjdw1J9LLM82HnFVVX19KY1uA5mu0QqEWhqKpoW3svG3XHrXDiCQjK1mdgAvhCscA9GE&client_secret=1955279925675241571" }
    let(:refresh_token) { "Ytwns3AKGIlTka3v9f6Md4kvZsMA9xNgMqVWdaNvBkfUaE7N6TbyVGEZ5eazoHJsa9RVgC5YvdbmPGeSZQNe3A" }

    context "all values set" do
      subject do
        described_class.new.tap do |c|
          c.api_version= api_version
          c.username = username
          c.password = password
          c.security_token = security_token
          c.host = host
          c.session_id = session_id
          c.instance = instance
          c.client_id = client_id
          c.client_secret = client_secret
          c.refresh_token = refresh_token
        end
      end

      let(:expected_hash) do
        {
          api_version: api_version,
          username: username,
          password: password,
          security_token: security_token,
          host: host,
          session_id: session_id,
          instance: instance,
          client_id: client_id,
          client_secret: client_secret,
          refresh_token: refresh_token,
        }
      end

      it "converts to expected hash" do
        expect(subject.to_h).to eq(expected_hash)
      end
    end

    context "some values missing" do
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
end
