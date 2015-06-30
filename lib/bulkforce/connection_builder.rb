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
      base_options = { api_version: api_version }

      session_options = if credentials[:session_id]
        {
          session_id: credentials[:session_id],
          instance: credentials.fetch(:instance),
        }
      elsif credentials[:refresh_token]
        Bulkforce::Http.oauth_login(
          host,
          credentials.fetch(:client_id),
          credentials.fetch(:client_secret),
          credentials[:refresh_token]
        )
      else
        Bulkforce::Http.login(
          host,
          credentials.fetch(:username),
          "#{credentials.fetch(:password)}#{credentials.fetch(:security_token)}",
          api_version
        )
      end.select { |k, _|  [:session_id, :instance].include?(k) }.to_h

      Bulkforce::Connection.new(base_options.merge(session_options))
    end
  end
end
