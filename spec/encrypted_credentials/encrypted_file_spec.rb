require "spec_helper"
require "encrypted_credentials/encrypted_file"
require "encrypted_credentials/coder"

module EncryptedCredentials
  RSpec.describe EncryptedFile do
    it "reads an encrypted file as yaml" do
      encrypted_credentials = file_fixture("credentials.yml.enc")

      encrypted_file = EncryptedFile.new(file: encrypted_credentials, coder: build_coder)
      credentials = encrypted_file.credentials

      expect(credentials.fetch("production")).to eq({ "key" => "secret" })
      expect(credentials.fetch("staging")).to eq(credentials.fetch("production"))
    end

    it "writes an encrypted file" do
      encrypted_credentials = file_fixture("credentials.yml.enc")

      FileUtils.mkdir_p("tmp")
      FileUtils.cp(encrypted_credentials, "tmp/credentials.yml.enc")

      encrypted_file = EncryptedFile.new(file: Pathname("tmp/credentials.yml.enc"), coder: build_coder)

      encrypted_file.write({ "foo" => "bar" }.to_yaml)
      credentials = encrypted_file.credentials

      expect(credentials).to eq({ "foo" => "bar" })
    end

    def build_coder
      Coder.new(key: file_fixture("master.key").read.chomp)
    end
  end
end
