# EncryptedCredentials

[![Build](https://github.com/somleng/encrypted_credentials/actions/workflows/main.yml/badge.svg)](https://github.com/somleng/encrypted_credentials/actions/workflows/main.yml)

Rails like [Encrypted credentials](https://guides.rubyonrails.org/security.html#environmental-security) for plain ruby with no dependencies.

## Installation

Add to the application's Gemfile:

```rb
# Gemfile

gem "encrypted_credentials", github: "somleng/encrypted_credentials"
```

## Usage

### Quick Start

### 1. Generate a default credentials file

```
bundle exec edit_credentials
```

Paste the following:

```yml
production: &production
  secret: "production-secret"

staging:
  <<: *production
  secret: "staging-secret"
```

### 2. Create an `app_settings.yml` in your config directory

```yml
# config/app_settings.yml

default: &default
  foo: bar
  secret: development-secret

production: &production
  <<: *default
  secret: "<%= app_settings.credentials.fetch('secret') %>"

staging:
  <<: *production
  secret: "<%= app_settings.credentials.fetch('secret') %>"
```

### 3. Create an `app_settings.rb` in your config directory

```rb
# config/app_settings.rb
require "encrypted_credentials/app_settings"

AppSettings = EncryptedCredentials::AppSettings.new(config_directory: File.expand_path(__dir__))
```

### 4. Run an IRB shell

```bash
APP_ENV=production irb
```

### 5. Play around

```rb
require "bundler/setup"
require_relative "config/app_settings"

AppSettings.env
# "production"

AppSettings.fetch(:foo)
# "bar"

AppSettings.fetch(:secret)
# "production-secret"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/somleng/encrypted_credentials.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
