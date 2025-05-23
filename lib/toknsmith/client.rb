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

    def logout
      response = HTTParty.delete(
        "#{@config.api_base}/api/v1/logout",
        headers: {
          "Authorization" => "Bearer #{@config.auth_token}",
          "Content-Type" => "application/json"
        }
      )

      case response.code
      when 200
        puts "✅ Token revoked remotely."
      when 401
        puts "⚠️ Token already revoked or invalid."
      else
        puts "Error: #{response.parsed_response["error"] || "Unknown error"}"
      end
    end

    def store_service_token(service_name, token_value, note = nil, expires_in = nil)
      body = {
        service_name: service_name,
        token_value: token_value,
        note: note,
        expires_in: expires_in
      }.compact

      post_service_token(body)
    end

    def configure_oauth_provider(provider, client_id, client_secret)
      body = {
        oauth_config: {
          provider_name: provider,
          client_id: client_id,
          client_secret: client_secret
        }
      }

      response = HTTParty.post(
        "#{@config.api_base}/api/v1/oauth_configs",
        headers: {
          "Authorization" => "Bearer #{@config.auth_token}",
          "Content-Type" => "application/json"
        },
        body: body.to_json
      )

      if response.success?
        true
      else
        error = response.parsed_response["error"] || response.parsed_response || "Unknown error"
        puts "Error saving OAuth config: #{error}"
        false
      end
    end

    def fetch_oauth_config(service)
      response = HTTParty.get(
        "#{@config.api_base}/api/v1/oauth_configs/#{service}",
        headers: {
          "Authorization" => "Bearer #{@config.auth_token}",
          "Content-Type" => "application/json"
        }
      )

      if response.code == 200
        response.parsed_response
      else
        puts "Error fetching OAuth config: #{response.parsed_response["error"] || "Unknown error"}"
        nil
      end
    end

    def auth_token
      @config.auth_token
    end

    def list_service_tokens
      response = HTTParty.get(
        "#{@config.api_base}/api/v1/service_tokens",
        headers: {
          "Authorization" => "Bearer #{@config.auth_token}",
          "Content-Type" => "application/json"
        }
      )

      case response.code
      when 200
        tokens = response.parsed_response
        puts "No service tokens found for your team." if tokens.empty?
        tokens
      else
        puts "Error: #{response.parsed_response["error"] || "Unknown error"}"
        []
      end
    end

    private

    def post_service_token(body)
      response = HTTParty.post(
        "#{@config.api_base}/api/v1/service_tokens",
        headers: {
          "Authorization" => "Bearer #{@config.auth_token}",
          "Content-Type" => "application/json"
        },
        body: body.to_json
      )

      case response.code
      when 201
        response.parsed_response
      else
        puts "Error: #{response.parsed_response["error"] || "Unknown error"}"
        nil
      end
    end
  end
end
