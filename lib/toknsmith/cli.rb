require "thor"
require_relative "client"
require_relative "keychain"
require_relative "client_config"

module Toknsmith
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

    desc "login TOKEN", "Store your auth token securely in macOS keychain"
    def login(token)
      Keychain.save(token)
      puts "✅ Token saved securely to Keychain!"
    end
  end
end
