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

      if client_secret.empty?
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
  end
end
