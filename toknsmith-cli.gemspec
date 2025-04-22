# frozen_string_literal: true

require_relative "lib/toknsmith/cli/cli_version"

Gem::Specification.new do |spec|
  spec.name = "toknsmith-cli"
  spec.version = Toknsmith::CliVersion::VERSION
  spec.authors = ["ToriK17"]
  spec.email = ["vfcad@protonmail.com"]

  spec.summary = "CLI client to interface with Toknsmith"
  spec.description = "CLI client to interface with Toknsmith"
  spec.homepage = "https://github.com/ToriK17/toknsmith-cli"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"
  spec.add_dependency "thor", "~> 1.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ToriK17/toknsmith-cli"
  spec.metadata["changelog_uri"] = "https://github.com/ToriK17/toknsmith-cli/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = ["toknsmith"]
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
