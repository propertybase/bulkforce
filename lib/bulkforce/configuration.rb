class Bulkforce
  class Configuration
    attr_accessor :api_version
    attr_accessor :username
    attr_accessor :password
    attr_accessor :security_token
    attr_accessor :host
    attr_accessor :session_id
    attr_accessor :instance

    def initialize
      @api_version = ENV["SALESFORCE_API_VERSION"] || "33.0"
      @username = ENV["SALESFORCE_USERNAME"]
      @password = ENV["SALESFORCE_PASSWORD"]
      @security_token = ENV["SALESFORCE_SECURITY_TOKEN"]
      @host = ENV["SALESFORCE_HOST"] || "login.salesforce.com"
      @session_id = ENV["SALESFORCE_SESSION_ID"]
      @instance = ENV["SALESFORCE_INSTANCE"]
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
      }.reject { |_, v| v.nil? }.to_h
    end
  end
end
