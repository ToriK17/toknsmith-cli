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

      oauth_config = client.fetch_oauth_config(service)

      unless oauth_config
        puts "❌ No OAuth config found for #{service}."
        return
      end

      client_id = oauth_config["client_id"]
      # NOTE: we don't need client_secret here, only client_id for GitHub authorize link

      redirect_uri = "http://localhost:7071/api/github-callback"
      query = URI.encode_www_form(
        client_id: client_id,
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
