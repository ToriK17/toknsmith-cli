require "shellwords"

module Toknsmith
  class Keychain
    SERVICE = "toknsmith"
    ACCOUNT = "auth_token"

    def self.save(token)
      system("security add-generic-password -a #{ACCOUNT} -s #{SERVICE} -w #{Shellwords.escape(token)} -U")
    end

    def self.load
      `security find-generic-password -a #{ACCOUNT} -s #{SERVICE} -w 2>/dev/null`.strip
    end

    def self.delete
      system("security delete-generic-password -a #{ACCOUNT} -s #{SERVICE} 2>/dev/null")
    end
  end
end
