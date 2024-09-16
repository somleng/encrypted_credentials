# frozen_string_literal: true

require "yaml"
require "base64"
require_relative "coder"

module EncryptedCredentials
  class EncryptedFile
    attr_reader :file, :coder

    def initialize(file:, **options)
      @file = file
      @coder = options.fetch(:coder) { Coder.new }
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
