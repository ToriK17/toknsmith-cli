# frozen_string_literal: true

require "thor"
require_relative "client"

module Toknsmith
  # Handles OAuth provider configurations
  class Oauth < Thor
    desc "configure PROVIDER", "Configure OAuth credentials for a service (e.g. github)"
    def configure(provider)
      client = Client.new
      auth_token = client.auth_token

      unless auth_token
        puts "❌ No auth token found. Please login first with `toknsmith login`."
        return
      end

      print "🔑 Client ID: "
      client_id = $stdin.gets.strip

      print "🔒 Client Secret: "
      client_secret = $stdin.noecho(&:gets).strip
      puts "\nSubmitting credentials..."

      if client_secret.strip.empty?
        puts "❌ Client Secret cannot be blank!"
        return
      end
      response = client.configure_oauth_provider(provider, client_id, client_secret)

      if response
        puts "✅ Successfully configured #{provider}!"
      else
        puts "❌ Failed to configure #{provider}."
      end
    rescue StandardError => e
      puts "Error during OAuth configuration: #{e.message}"
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
  end
end
