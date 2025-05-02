# frozen_string_literal: true

require "thor"
require_relative "service_tokens"
require_relative "oauth_tokens"

module Toknsmith
  # Parent CLI command to route token subcommands
  class Tokens < Thor
    desc "service SUBCOMMAND", "Manage service tokens (e.g. GitHub PATs)"
    subcommand "service", ServiceTokens

    desc "oauth SUBCOMMAND", "Manage OAuth tokens (via provider flows)"
    subcommand "oauth", OauthTokens
  end
end
