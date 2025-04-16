require "httparty"
require_relative "client_config"

module Toknsmith
  class Client
    def initialize
      @config = ClientConfig.new
    end

    def whoami
      response = HTTParty.get(
        "#{@config.api_base}/api/v1/whoami",
        headers: {
          "Authorization" => "Bearer #{@config.auth_token}",
          "Content-Type" => "application/json"
        }
      )

      case response.code
      when 200
        puts "You are: #{response["email"]}"
      else
        puts "Failed to authenticate. Status: #{response.code}"
      end
    end
  end
end
