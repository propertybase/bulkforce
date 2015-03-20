#encoding: utf-8
require "spec_helper"

describe Bulkforce::ConnectionBuilder do
  describe "#build" do
    subject { described_class.new(options) }

    before(:each) do
      allow(Bulkforce::Http).to receive(:login).and_return(sessoion_id: "org_id!session_id", instance: "eu2")
    end

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

      let(:host) { "login.salesforce.com" }
      let(:username) { "leif@home.com" }
      let(:password) { "password" }
      let(:security_token) { "security_token" }
      let(:api_version) { "33.0" }

      it "returns a connection" do
        expect(subject.build).to be_a(Bulkforce::Connection)
      end

      it "triggers login with username, password and security token" do
        subject.build
        expect(Bulkforce::Http).
          to have_received(:login).
          with(host, username, "#{password}#{security_token}", api_version)
      end
    end
  end
end
