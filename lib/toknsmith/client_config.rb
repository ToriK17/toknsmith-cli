require "yaml"

module Toknsmith
  class ClientConfig
    CONFIG_PATH = File.join(Dir.home, ".toknsmith", "config")

    def api_base
      @api_base ||= begin
        raise "Missing API base config. Create #{CONFIG_PATH} with an 'api_base' key." unless File.exist?(CONFIG_PATH)

        config = YAML.load_file(CONFIG_PATH)
        config["api_base"]
      end
    end

    def auth_token
      token = `security find-generic-password -a auth_token -s toknsmith -w 2>/dev/null`.strip
      raise "No auth token found. Please run `toknsmith-cli login`." if token.empty?

      token
    end
  end
end
