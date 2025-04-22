# frozen_string_literal: true

require "httparty"
require_relative "client_config"
require "json"

module Toknsmith
  # Handles API interactions including authentication and identity verification.
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

    def login(email, password)
      response = HTTParty.post(
        "#{@config.api_base}/api/v1/login",
        headers: { "Content-Type" => "application/json" },
        body: {
          session: {
            email: email,
            password: password
          }
        }.to_json
      )

      case response.code
      when 200
        response["auth_token"]
      else
        puts "Error: #{response.parsed_response["error"] || "Unknown error"}"
        nil
      end
    end
  end
end
