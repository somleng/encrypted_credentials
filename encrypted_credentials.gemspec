# frozen_string_literal: true

require_relative "lib/encrypted_credentials/version"

Gem::Specification.new do |spec|
  spec.name = "encrypted_credentials"
  spec.version = EncryptedCredentials::VERSION
  spec.authors = [ "David Wilkie" ]
  spec.email = [ "dwilkie@gmail.com" ]

  spec.summary = "Encrypted Credentials"
  spec.description = "Encrypted credentials without Rails"
  spec.homepage = "https://github.com/somleng/encrypted_credentials"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/somleng/encrypted_credentials"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = [ "lib" ]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "ostruct"
  spec.add_dependency "base64"

  spec.add_development_dependency "aws-sdk-ssm"
  spec.add_development_dependency "ox"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
