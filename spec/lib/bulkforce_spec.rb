#encoding: utf-8
require "spec_helper"

describe Bulkforce do
  subject { described_class }
  let(:client) { subject.new(username: nil, password: nil, security_token: nil) }
  let!(:connection_builder_class) { class_spy("Bulkforce::ConnectionBuilder", new: connection_builder).as_stubbed_const }
  let(:connection_builder) { instance_spy("Bulkforce::ConnectionBuilder", build: empty_connection) }

  let(:empty_connection) { instance_spy("Bulkforce::Connection") }

  let(:empty_batch) do
    Object.new
  end

  before(:each) do
    allow_any_instance_of(Bulkforce::ConnectionBuilder).to receive(:build).and_return(empty_connection)
  end

  {
    upsert: [nil,[{"no" => "value"}], "upsert_id"],
    update: [nil,[{"no" => "value"}]],
    insert: [nil,[{"no" => "value"}]],
    delete: [nil,[{"no" => "value"}]],
  }.each do |method_name, values|
    describe "##{method_name}" do
      it "delegates to #start_job" do
        s = client
        expect(s).to receive(:start_job)
          .with(method_name.to_s, *values)
        s.send(method_name, *values)
      end

      it "triggers correct workflow" do
        s = client
        expect(empty_connection).to receive(:create_job).ordered
        expect(empty_connection).to receive(:add_batch).ordered
        expect(empty_connection).to receive(:close_job).ordered
        res = s.send(method_name, *values)
        expect(res).to be_a(Bulkforce::Batch)
      end
    end
  end

  describe "#query" do
    it "triggers correct workflow" do
        expect(Bulkforce::Batch)
          .to receive(:new)
        .and_return(empty_batch)

      s = client
      sobject_input = "sobject_stub"
      query_input = "query_stub"
      expect(empty_connection).to receive(:create_job).ordered
      expect(empty_connection).to receive(:add_query).ordered
      expect(empty_connection).to receive(:close_job).ordered
      expect(empty_batch).to receive(:final_status).ordered
      s.query(sobject_input, query_input)
    end
  end

  describe "#configure" do
    let(:api_version) { "spec_33.0" }
    let(:username) { "spec_user" }
    let(:password) { "spec_password" }
    let(:security_token) { "spec_security_token" }
    let(:host) { "spec_host" }

    it "yields a configuration object" do
      expect { |b| subject.configure(&b) }.to yield_with_args(an_instance_of(Bulkforce::Configuration))
    end

    it "passes correct values to connection builder", :aggregate_failures do
      subject.configure do |config|
        config.api_version = api_version
        config.username = username
        config.password = password
        config.security_token = security_token
        config.host = host
      end
      subject.new
      expect(connection_builder_class).to have_received(:new).with(
        api_version: api_version,
        username: username,
        password: password,
        security_token: security_token,
        host: host,
      )
    end
  end

  context "file upload" do
    describe "#insert" do
      prefix = Dir.tmpdir
      FileUtils.touch("#{prefix}/attachment.pdf")
      attachment_data = {
        "ParentId" => "00Kk0001908kqkDEAQ",
        "Name" => "attachment.pdf",
        "Body" => File.new("#{prefix}/attachment.pdf")
      }

      {
        upsert: [nil,[attachment_data.dup], "upsert_id"],
        update: [nil,[attachment_data.dup]],
        insert: [nil,[attachment_data.dup]],
        delete: [nil,[attachment_data.dup]],
      }.each do |method_name, values|
        describe "##{method_name}" do
          it "delegates to #start_job" do
            s = client
            expect(s).to receive(:start_job)
              .with(method_name.to_s, *values)
            s.send(method_name, *values)
          end

          it "triggers correct workflow" do
            s = client
            expect(empty_connection).to receive(:create_job).ordered
            expect(empty_connection).to receive(:add_file_upload_batch).ordered
            expect(empty_connection).to receive(:close_job).ordered
            res = s.send(method_name, *values)
            expect(res).to be_a(Bulkforce::Batch)
          end
        end
      end
    end
  end
end
