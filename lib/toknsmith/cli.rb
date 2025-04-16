# frozen_string_literal: true

require "thor"
require_relative "cli/cli_version"
require_relative "client"

module Toknsmith
  class CLI < Thor
    class Error < StandardError; end
    desc "whoami", "Check which user you're authenticated as"
    def whoami
      client = Client.new
      client.whoami
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end
