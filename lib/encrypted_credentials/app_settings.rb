require "yaml"
require "erb"
require "pathname"
require "ostruct"
require_relative "encrypted_file"

module EncryptedCredentials
  class AppSettings
    DEFAULT_SETTINGS_FILENAME = "app_settings.yml"
    DEFAULT_ENCRYPTED_FILENAME = "credentials.yml.enc"

    class Data
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def fetch(key)
        data.fetch(key.to_s)
      end

      def [](key)
        data[key.to_s]
      end
    end

    attr_reader :environment, :config_directory, :settings_filepath, :encrypted_filepath, :key_filepath, :encrypted_file, :credentials_root_key

    def initialize(**options)
      @environment = (options.fetch(:environment) { ENV.fetch("APP_ENV", "development") }).to_s
      @config_directory = Pathname(options.fetch(:config_directory)) if options.key?(:config_directory)
      @settings_filepath = Pathname(options.fetch(:settings_filepath) { default_settings_filepath })
      @encrypted_filepath = Pathname(options.fetch(:encrypted_filepath) { default_encrypted_filepath })
      @key_filepath = Pathname(options.fetch(:key_filepath) { default_key_filepath })
      @encrypted_file = options.fetch(:encrypted_file) { default_encrypted_file }
      @credentials_root_key = options.fetch(:credentials_root_key) { default_credentials_root_key }
    end

    def fetch(...)
      settings.fetch(...)
    end

    def [](*)
      settings[*]
    end

    def env
      environment
    end

    def credentials
      @credentials ||= begin
        data = YAML.load(encrypted_file.read, aliases: true)
        data = credentials_root_key.nil? ? data : data.fetch(credentials_root_key, {})
        Data.new(data)
      end
    end

    private

    def settings
      @settings ||= begin
        data = YAML.load(settings_filepath.read, aliases: true).fetch(env, {})
        Data.new(YAML.load(ERB.new(data.to_yaml).result(OpenStruct.new(app_settings: self).instance_eval { binding })))
      end
    end

    def default_settings_filepath
      config_directory.join(DEFAULT_SETTINGS_FILENAME)
    end

    def default_encrypted_filepath
      environment_credentials = config_directory.join("credentials", default_environment_credentials_filename)
      return environment_credentials if environment_credentials.exist?

      config_directory.join(DEFAULT_ENCRYPTED_FILENAME)
    end

    def default_key_filepath
      environment_key = config_directory.join("credentials", default_environment_key_filename)
      return environment_key if environment_key.exist?

      config_directory.join("master.key")
    end

    def default_encrypted_file
      return unless encrypted_filepath.exist?
      return if coder.nil?

      EncryptedFile.new(file: encrypted_filepath, coder:)
    end

    def coder
      @coder ||= begin
        if ENV.key?("APP_MASTER_KEY")
          Coder.new(key: ENV.fetch("APP_MASTER_KEY"))
        elsif key_filepath.exist?
          Coder.new(key: key_filepath.read.chomp)
        end
      end
    end

    def default_credentials_root_key
      return if encrypted_file.nil?
      return if encrypted_file.file.basename == Pathname(default_environment_credentials_filename)

      env
    end

    def default_environment_credentials_filename
      "#{env}.yml.enc"
    end

    def default_environment_key_filename
      "#{env}.key"
    end
  end
end
