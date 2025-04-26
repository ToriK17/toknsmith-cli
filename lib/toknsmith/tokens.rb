# frozen_string_literal: true

require "thor"
require_relative "client"
require "dotenv/load"

module Toknsmith
  # Handles CLI token storage for external services (e.g., GitHub)
  class Tokens < Thor
    desc "store SERVICE", "Store a token for a given service"
    option :token, required: true, aliases: "-t", desc: "The actual token value"
    option :note, aliases: "-n", desc: "Optional note for the token"
    option :expires_in, aliases: "-e", desc: "Optional expiration (e.g. '30d', '12h')"

    def store(service)
      client = Client.new
      response = client.store_token(service, options[:token], options[:note], options[:expires_in])

      if response
        print_token_result(service, response)
      else
        puts "❌ Failed to store token."
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
    end

    desc "list", "List stored tokens for your team"
    def list
      client = Client.new
      tokens = client.list_tokens

      if tokens.any?
        puts "🔐 Stored Tokens:"
        puts "ID\tService\t\tExpires\t\t\tNote"
        tokens.each do |t|
          puts "#{t["id"]}\t#{t["service_name"]}\t#{t["expires_at"] || "Never"}\t#{t["note"] || "-"}"
        end
      else
        puts "😴 No tokens stored yet."
      end
    rescue StandardError => e
      puts "Error: #{e.message}"
    end

    desc "connect SERVICE", "Initiate OAuth connection for a service (e.g. github)"
    def connect(service)
      client = Client.new
      auth_token = client.auth_token
      unless auth_token
        puts "❌ No auth token found. Please login first with `toknsmith login`."
        return
      end

      case service
      when "github"
        redirect_uri = "http://localhost:7071/api/github-callback"
        query = URI.encode_www_form(
          client_secret: ENV.fetch("GITHUB_CLIENT_SECRET", nil),
          client_id: ENV.fetch("GITHUB_CLIENT_ID", nil),
          redirect_uri: redirect_uri,
          state: "toknsmith:#{auth_token}"
        )
        oauth_url = "http://localhost:7071/api/github-authorize?#{query}"

        puts "🌐 Open this URL to connect your GitHub account:"
        puts oauth_url
        # Optional: auto-open browser
        case RbConfig::CONFIG["host_os"]
        when /darwin|mac os/
          system("open", oauth_url)
        when /linux/
          system("xdg-open", oauth_url)
        when /mswin|mingw|cygwin/
          system("start", oauth_url)
        end
      else
        puts "⚠️ Service not yet supported: #{service}"
      end
    rescue StandardError => e
      puts "Error starting OAuth flow: #{e.message}"
    end

    private

    def print_token_result(service, response)
      puts "🔐 Token for #{service} stored securely."
      puts "ID: #{response["id"]}"
      puts "Note: #{response["note"]}" if response["note"]
      puts "Expires: #{response["expires_at"]}" if response["expires_at"]
    end
  end
end
