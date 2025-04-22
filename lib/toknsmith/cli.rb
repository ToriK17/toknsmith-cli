# frozen_string_literal: true

require "thor"
require_relative "client"
require_relative "keychain"
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
        puts "✅ Logged in and token saved to Keychain!"
      else
        puts "❌ Login failed. Please check your credentials."
      end
    rescue StandardError => e
      puts "Error during login: #{e.message}"
    end

    desc "logout", "Remove your stored auth token from local keychain"
    def logout
      if Keychain.clear
        puts "👋 Logged out. Token removed from Keychain."
      else
        puts "⚠️ No token found in Keychain."
      end
    rescue StandardError => e
      puts "Error during logout: #{e.message}"
    end
  end
end
