require "spec_helper"

module EncryptedCredentials
  RSpec.describe AppSettings do
    it "handles app settings" do
      app_settings = TestAppSettings.new

      expect(app_settings.env).to eq("production")
      expect(app_settings.fetch(:foo)).to eq("bar")
      expect(app_settings[:secret]).to eq("secret")
    end
  end
end
