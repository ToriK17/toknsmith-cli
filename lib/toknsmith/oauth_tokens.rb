# frozen_string_literal: true

require "thor"
require_relative "client"
require "uri"

module Toknsmith
  # Handles OAuth provider configurations
  class OauthTokens < Thor
    desc "configure PROVIDER", "Configure OAuth credentials for a service (e.g. github, heroku)"
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

    desc "connect SERVICE", "Initiate OAuth connection for a service (e.g. github, heroku)"
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
      state = "toknsmith:#{auth_token}"
      azure_base = ENV.fetch("AZURE_MIDDLEWARE_URL", "http://localhost:7071/api")

      redirect_path = "#{service}-authorize"
      redirect_url = URI.join("#{azure_base}/", redirect_path).to_s

      query = URI.encode_www_form(
        client_id: client_id,
        redirect_uri: "#{azure_base}/#{service}-callback",
        state: state
      )

      full_url = "#{redirect_url}?#{query}"

      puts "🌐 Opening browser to authorize your #{service.capitalize} account..."

      # fallback print just in case it doesn't open
      puts full_url

      case RbConfig::CONFIG["host_os"]
      when /darwin|mac os/
        system("open", full_url)
      when /linux/
        system("xdg-open", full_url)
      when /mswin|mingw|cygwin/
        system("start", full_url)
      else
        puts "🔗 Please open the URL manually:"
        puts full_url
      end
    rescue StandardError => e
      puts "Error starting OAuth flow: #{e.message}"
    end
  end
end
