require "spec_helper"
require "encrypted_credentials/encrypted_file"
require "encrypted_credentials/coder"
require "yaml"

module EncryptedCredentials
  RSpec.describe EncryptedFile do
    it "reads an encrypted file" do
      encrypted_credentials = file_fixture("test_config/credentials.yml.enc")

      encrypted_file = EncryptedFile.new(file: encrypted_credentials, coder: build_coder)
      result = YAML.load(encrypted_file.read, aliases: true)

      expect(result.fetch("production")).to eq({ "secret" => "production-secret" })
    end

    it "writes an encrypted file" do
      encrypted_credentials = file_fixture("test_config/credentials.yml.enc")

      FileUtils.mkdir_p("tmp")
      FileUtils.cp(encrypted_credentials, "tmp/credentials.yml.enc")

      encrypted_file = EncryptedFile.new(file: Pathname("tmp/credentials.yml.enc"), coder: build_coder)

      encrypted_file.write({ "foo" => "bar" }.to_yaml)
      content = YAML.load(encrypted_file.read)

      expect(content).to eq({ "foo" => "bar" })
    end

    def build_coder
      Coder.new(key: file_fixture("test_config/master.key").read.chomp)
    end
  end
end
