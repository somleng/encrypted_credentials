require "spec_helper"
require "encrypted_credentials/coder"
require "securerandom"

module EncryptedCredentials
  RSpec.describe Coder do
    it "encrypts and decrypts" do
      coder = Coder.new(key: SecureRandom.alphanumeric(64))
      content = "bar"

      encrypted_content = coder.encrypt(content)

      expect(coder.decrypt(encrypted_content)).to eq(content)
    end
  end
end
