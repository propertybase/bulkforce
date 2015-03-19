class Bulkforce
  class Connection
    attr_reader :raw_request
    attr_reader :raw_result

    def initialize(username, password, api_version, sandbox)
      @username = username
      @password = password
      @api_version = api_version
      @sandbox = sandbox
    end

    def login
      response = Bulkforce::Http.login(
        @sandbox,
        @username,
        @password,
        @api_version)

      @session_id = response[:session_id]
      @instance = response[:instance]
      self
    end

    def org_id
      raise "please login first" unless @session_id
      @session_id.split("!").first
    end

    def create_job operation, sobject, content_type, external_field
      Bulkforce::Http.create_job(
        @instance,
        @session_id,
        operation,
        sobject,
        content_type,
        @api_version,
        external_field)[:id]
    end

    def close_job job_id
      Bulkforce::Http.close_job(
        @instance,
        @session_id,
        job_id,
        @api_version)[:id]
    end

    def add_query job_id, data_or_soql
      Bulkforce::Http.add_batch(
        @instance,
        @session_id,
        job_id,
        data_or_soql,
        @api_version)[:id]
    end

    def query_batch job_id, batch_id
      Bulkforce::Http.query_batch(
        @instance,
        @session_id,
        job_id,
        batch_id,
        @api_version,
      )
    end

    def query_batch_result_id job_id, batch_id
      Bulkforce::Http.query_batch_result_id(
        @instance,
        @session_id,
        job_id,
        batch_id,
        @api_version,
      )
    end

    def query_batch_result_data job_id, batch_id, result_id
      @raw_result = Bulkforce::Http.query_batch_result_data(
        @instance,
        @session_id,
        job_id,
        batch_id,
        result_id,
        @api_version,
      )
      Bulkforce::Helper.parse_csv @raw_result
    end

    def add_file_upload_batch job_id, filename
      @raw_request = File.read(filename)
      Bulkforce::Http.add_file_upload_batch(
        @instance,
        @session_id,
        job_id,
        @raw_request,
        @api_version)[:id]
    end

    def add_batch job_id, records
      return -1 if records.nil? || records.empty?
      @raw_request = Bulkforce::Helper.records_to_csv(records)

      Bulkforce::Http.add_batch(
        @instance,
        @session_id,
        job_id,
        @raw_request,
        @api_version)[:id]
    end

    def self.connect(username, password, api_version, sandbox)
      self.new(username, password, api_version, sandbox).login
    end
  end
end
