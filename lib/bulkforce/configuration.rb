class Bulkforce
  class Configuration
    attr_accessor :api_version
    attr_accessor :username
    attr_accessor :password
    attr_accessor :security_token
    attr_accessor :host

    def initialize
      @api_version = ENV["SALESFORCE_API_VERSION"] || "33.0"
      @username = ENV["SALESFORCE_USERNAME"]
      @password = ENV["SALESFORCE_PASSWORD"]
      @security_token = ENV["SALESFORCE_SECURITY_TOKEN"]
      @host = ENV["SALESFORCE_HOST"] || "login.salesforce.com"
    end

    def to_h
      {
        api_version: api_version,
        username: username,
        password: password,
        security_token: security_token,
        host: host,
      }
    end
  end
end
