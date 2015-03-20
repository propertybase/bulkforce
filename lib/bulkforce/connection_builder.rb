class Bulkforce
  class ConnectionBuilder
    attr_reader :host
    attr_reader :api_version
    attr_reader :credentials

    def initialize(host:, api_version:, **credentials)
      @host = host
      @api_version = api_version
      @credentials = credentials
    end

    def build
      response = Bulkforce::Http.login(
        host,
        credentials.fetch(:username),
        "#{credentials.fetch(:password)}#{credentials.fetch(:security_token)}",
        api_version
      )
      Bulkforce::Connection.new(
        session_id: response[:session_id],
        instance: response[:instance],
        api_version: api_version
      )
    end
  end
end
