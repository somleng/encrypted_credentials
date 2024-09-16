require "encrypted_credentials/app_settings"
require "encrypted_credentials/encrypted_file"
require "encrypted_credentials/coder"

class TestAppSettings < EncryptedCredentials::AppSettings
  def initialize(**options)
    super(file: Pathname(file_fixture("app_settings.yml")), encrypted_file:, environment: :production, **options)
  end

  private

  def encrypted_file
    @encrypted_file ||= EncryptedCredentials::EncryptedFile.new(file: Pathname(file_fixture("credentials.yml.enc")), coder:)
  end

  def coder
    @coder = EncryptedCredentials::Coder.new(key: File.read(file_fixture("master.key")).chomp)
  end

  def file_fixture(filename)
    File.expand_path("../fixtures/files/#{filename}", __dir__)
  end
end
