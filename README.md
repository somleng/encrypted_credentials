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

Given the following files:

```yml
# config/app_settings.yml

default: &default
  foo: "bar"
  password: "secret"

production: &production
  <<: *default
  password: "<%= AppSettings.credentials.fetch('password') %>"

staging:
  <<: *production

development: &development
  <<: *default

test:
  <<: *development
```

```yml
# config/credentials.yml.enc
# edit this file by running:
# bundle exec edit_credentials -f config/credentials.yml.enc -k config/master.key

production: &production
  password: "super-secret"

staging:
  <<: *production
```

```rb
# config/app_settings.rb
require "encrypted_credentials/app_settings"
require "encrypted_credentials/encrypted_file"

AppSettings = Class.new(EncryptedCredentials::AppSettings) do
  def initialize(**)
    super(
      file: Pathname(File.expand_path("app_settings.yml", __dir__)),
      encrypted_file: EncryptedCredentials::EncryptedFile.new(
        file: Pathname(File.expand_path("credentials.yml.enc", __dir__))
      )
      **
    )
  end
end.new
```

```bash
APP_ENV=production ./bin/console
```

```rb
AppSettings.env
# "production"

AppSettings.fetch(:password)
# "super-secret"

AppSettings.fetch(:foo)
# "bar"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/somleng/encrypted_credentials.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
