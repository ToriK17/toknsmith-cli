# frozen_string_literal: true

require "thor"
require_relative "client"

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

    private

    def print_token_result(service, response)
      puts "🔐 Token for #{service} stored securely."
      puts "ID: #{response["id"]}"
      puts "Note: #{response["note"]}" if response["note"]
      puts "Expires: #{response["expires_at"]}" if response["expires_at"]
    end
  end
end
