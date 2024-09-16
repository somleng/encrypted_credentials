require "openssl"

module EncryptedCredentials
  class Coder
    DEFAULT_ALGORITHM = "aes-256-cbc"

    attr_reader :algorithm

    def initialize(**options)
      @key = options.fetch(:key) { -> { ENV.fetch("APP_MASTER_KEY") } }
      @algorithm = options.fetch(:algorithm, DEFAULT_ALGORITHM)
    end

    def encrypt(content)
      cipher = OpenSSL::Cipher.new(algorithm)
      cipher.encrypt
      cipher.key = [ key ].pack("H*")
      cipher.update(content) + cipher.final
    end

    def decrypt(content)
      cipher = OpenSSL::Cipher.new(algorithm)
      cipher.decrypt
      cipher.key = [ key ].pack("H*")
      cipher.update(content) + cipher.final
    end

    private

    def key
      @key.respond_to?(:call) ? @key.call : @key
    end
  end
end
