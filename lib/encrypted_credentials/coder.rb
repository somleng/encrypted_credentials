require "openssl"

module EncryptedCredentials
  class Coder
    DEFAULT_ALGORITHM = "aes-256-cbc"

    attr_reader :key, :algorithm

    def initialize(key:, algorithm: DEFAULT_ALGORITHM)
      @key = key
      @algorithm = algorithm
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
  end
end
