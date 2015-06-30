#encoding: utf-8
require "spec_helper"

describe Bulkforce::ConnectionBuilder do
  describe "#build" do
    subject { described_class.new(options) }
    let!(:session_id) { "org_id!session_id" }
    let!(:instance) { "eu2" }

    before(:each) do
      allow(Bulkforce::Http).to receive(:login).and_return(session_id: "org_id!session_id", instance: "eu2")
      allow(Bulkforce::Http).to receive(:oauth_login).and_return(session_id: "org_id!session_id", instance: "eu2")
    end

    let(:host) { "login.salesforce.com" }
    let(:api_version) { "33.0" }
    let(:connection) { subject.build }

    context "username/password" do
      let(:options) do
        {
          host: host,
          username: username,
          password: password,
          security_token: security_token,
          api_version: api_version,
        }
      end

      let(:username) { "leif@home.com" }
      let(:password) { "password" }
      let(:security_token) { "security_token" }

      it "returns a connection" do
        expect(connection).to be_a(Bulkforce::Connection)
      end

      it "triggers login with username, password and security token" do
        subject.build
        expect(Bulkforce::Http).
          to have_received(:login).
          with(host, username, "#{password}#{security_token}", api_version)
      end

      it "builds connection with correct attributes", :aggregate_failures do
        expect(connection.instance_variable_get("@session_id")).to eq(session_id)
        expect(connection.instance_variable_get("@instance")).to eq(instance)
        expect(connection.instance_variable_get("@api_version")).to eq(api_version)
      end
    end

    context "session id" do
      let(:options) do
        {
          host: host,
          session_id: session_id,
          instance: instance,
          api_version: api_version,
        }
      end

      let(:session_id) { "00Dx0000000BV7z!AR8AQP0jITN80ESEsj5EbaZTFG0RNBaT1cyWk7TrqoDjoNIWQ2ME_sTZzBjfmOE6zMHq6y8PIW4eWze9JksNEkWUl.Cju7m4" }
      let(:instance) { "eu2" }

      it "returns a connection" do
        expect(subject.build).to be_a(Bulkforce::Connection)
      end

      it "does not trigger HTTP login workflow" do
        subject.build
        expect(Bulkforce::Http).not_to have_received(:login)
      end

      it "builds connection with correct attributes", :aggregate_failures do
        expect(connection.instance_variable_get("@session_id")).to eq(session_id)
        expect(connection.instance_variable_get("@instance")).to eq(instance)
        expect(connection.instance_variable_get("@api_version")).to eq(api_version)
      end
    end

    context "oauth refresh token" do
      let(:options) do
        {
          host: host,
          client_id: client_id,
          client_secret: client_secret,
          refresh_token: refresh_token,
          api_version: api_version,
        }
      end

      let(:client_id) { "3MVG9lKcPoNINVBIPJjdw1J9LLM82HnFVVX19KY1uA5mu0QqEWhqKpoW3svG3XHrXDiCQjK1mdgAvhCscA9GE&client_secret=1955279925675241571" }
      let(:client_secret) { "3MVG9lKcPoNINVBIPJjdw1J9LLM82HnFVVX19KY1uA5mu0QqEWhqKpoW3svG3XHrXDiCQjK1mdgAvhCscA9GE&client_secret=1955279925675241571" }
      let(:refresh_token) { "Ytwns3AKGIlTka3v9f6Md4kvZsMA9xNgMqVWdaNvBkfUaE7N6TbyVGEZ5eazoHJsa9RVgC5YvdbmPGeSZQNe3A" }

      it "returns a connection" do
        expect(connection).to be_a(Bulkforce::Connection)
      end

      it "triggers login with username, password and security token" do
        subject.build
        expect(Bulkforce::Http).
          to have_received(:oauth_login).
          with(host, client_id, client_secret, refresh_token)
      end

      it "builds connection with correct attributes", :aggregate_failures do
        expect(connection.instance_variable_get("@session_id")).to eq(session_id)
        expect(connection.instance_variable_get("@instance")).to eq(instance)
        expect(connection.instance_variable_get("@api_version")).to eq(api_version)
      end
    end
  end
end
