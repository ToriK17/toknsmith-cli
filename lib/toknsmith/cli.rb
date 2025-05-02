# frozen_string_literal: true

require "thor"
require_relative "client"
require_relative "keychain"
require_relative "tokens"
require_relative "service_tokens"
require_relative "oauth_tokens"
require_relative "client_config"
require "io/console"
module Toknsmith
  # A command-line interface for logging in and saving tokens
  class CLI < Thor
    def self.exit_on_failure?
      true
    end

    desc "whoami", "Check which user you're authenticated as"
    def whoami
      client = Client.new
      client.whoami
    rescue StandardError => e
      puts "Error: #{e.message}"
    end

    desc "login", "Log in with your email and password to receive an auth token"
    def login
      print "Email: "
      email = $stdin.gets.strip

      print "Password: "
      password = $stdin.noecho(&:gets).strip
      puts "\nLogging in..."

      client = Client.new
      auth_token = client.login(email, password)

      if auth_token
        Keychain.save(auth_token)
        puts "✅ Logged in and auth token saved to Keychain!"
      else
        puts "❌ Login failed. Please check your credentials."
      end
    rescue StandardError => e
      puts "Error during login: #{e.message}"
    end

    desc "logout", "Revoke your auth token and remove it from local keychain"
    def logout
      client = Client.new
      client.logout

      if Keychain.clear
        puts "👋 Logged out locally. Auth token removed from Keychain."
      else
        puts "⚠️ No auth token found in Keychain."
      end
    rescue StandardError => e
      puts "Error during logout: #{e.message}"
    end

    desc "tokens SUBCOMMAND ...ARGS", "Token-related operations"
    subcommand "tokens", Tokens

    desc "oauth SUBCOMMAND ...ARGS", "OAuth provider operations"
    subcommand "oauth", OauthTokens
  end
end
