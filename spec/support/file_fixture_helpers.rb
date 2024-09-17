require "pathname"

module FileFixtureHelpers
  def file_fixture(filename)
    file_fixture_path.join(filename)
  end

  def file_fixture_path
    Pathname(File.expand_path("../fixtures/files", __dir__))
  end
end

RSpec.configure do |config|
  config.include(FileFixtureHelpers)
end
