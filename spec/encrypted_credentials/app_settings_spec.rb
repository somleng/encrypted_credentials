require "spec_helper"
require "encrypted_credentials/app_settings"

module EncryptedCredentials
  RSpec.describe AppSettings do
    it "handles combined environment credentials" do
      app_settings = build_app_settings(environment: :production)

      expect(app_settings.env).to eq("production")
      expect(app_settings.fetch(:secret)).to eq("production-secret")
      expect(app_settings[:foo]).to eq("bar")
      expect(app_settings.credentials.fetch(:secret)).to eq("production-secret")
    end

    it "handles environment specific credentials" do
      app_settings = build_app_settings(environment: :staging)

      expect(app_settings.env).to eq("staging")
      expect(app_settings.fetch(:secret)).to eq("staging-secret")
      expect(app_settings[:foo]).to eq("bar")
      expect(app_settings.credentials.fetch(:secret)).to eq("staging-secret")
    end

    it "handles lazy loading of the APP_MASTER_KEY" do
      app_settings = build_app_settings(
        environment: :production,
        settings_filepath: file_fixture("test_config/app_settings.yml"),
        encrypted_filepath: file_fixture("test_config/credentials.yml.enc"),
        key_filepath: file_fixture("test_config/no-key.key")
      )

      expect(app_settings.env).to eq("production")

      stub_env("APP_MASTER_KEY" => file_fixture("test_config/master.key").read.chomp)

      expect(app_settings[:foo]).to eq("bar")
      expect(app_settings.fetch(:secret)).to eq("production-secret")
    end

    def build_app_settings(**)
      Class.new(AppSettings).new(config_directory: file_fixture_path.join("test_config"), **)
    end
  end
end
