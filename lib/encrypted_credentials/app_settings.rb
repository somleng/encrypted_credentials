require "yaml"
require "erb"
require "pathname"

module EncryptedCredentials
  class AppSettings
    attr_reader :file, :encrypted_file, :environment

    def initialize(file:, **options)
      @file = file
      @encrypted_file = options[:encrypted_file]
      @environment = (options.fetch(:environment) { ENV.fetch("APP_ENV", "development") }).to_s
    end

    def fetch(key)
      settings.fetch(key.to_s)
    end

    def env
      environment
    end

    def [](key)
      settings[key.to_s]
    end

    def credentials
      @credentials ||= encrypted_file.credentials.fetch(env, {})
    end

    private

    def settings
      @settings ||= begin
        data = YAML.load(file.read, aliases: true).fetch(env, {})
        YAML.load(ERB.new(data.to_yaml).result)
      end
    end
  end
end
