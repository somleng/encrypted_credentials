# frozen_string_literal: true

require "yaml"
require "base64"

module EncryptedCredentials
  class EncryptedFile
    attr_reader :file, :coder

    def initialize(file:, coder:)
      @file = file
      @coder = coder
    end

    def credentials
      content = read
      YAML.load(content, aliases: true)
    end

    def read
      encrypted_content = Base64.strict_decode64(file.binread)
      coder.decrypt(encrypted_content)
    end

    def write(content)
      encrypted_content = coder.encrypt(content)
      file.binwrite(Base64.strict_encode64(encrypted_content))
    end
  end
end
