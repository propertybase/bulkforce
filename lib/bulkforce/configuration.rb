class Bulkforce
  class Configuration
    attr_accessor :api_version
    attr_accessor :username
    attr_accessor :password
    attr_accessor :security_token
    attr_accessor :host
    attr_accessor :session_id
    attr_accessor :instance
    attr_accessor :client_id
    attr_accessor :client_secret
    attr_accessor :refresh_token

    def initialize
      @api_version = ENV["SALESFORCE_API_VERSION"] || "33.0"
      @username = ENV["SALESFORCE_USERNAME"]
      @password = ENV["SALESFORCE_PASSWORD"]
      @security_token = ENV["SALESFORCE_SECURITY_TOKEN"]
      @host = ENV["SALESFORCE_HOST"] || "login.salesforce.com"
      @session_id = ENV["SALESFORCE_SESSION_ID"]
      @instance = ENV["SALESFORCE_INSTANCE"]
      @client_id = ENV["SALESFORCE_CLIENT_ID"]
      @client_secret = ENV["SALESFORCE_CLIENT_SECRET"]
      @refresh_token = ENV["SALESFORCE_REFRESH_TOKEN"]
    end

    def to_h
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
      }.reject { |_, v| v.nil? }.to_h
    end
  end
end
