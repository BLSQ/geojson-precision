require "bundler/setup"

require "simplecov"
SimpleCov.start "rails" do
  coverage_dir  "./coverage"
  add_filter    "/spec/"
  add_filter    "/test/"
  add_filter    "/lib/geojson/precision/version"

end

require "geojson/precision"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_content(type, name)
  File.read(File.join("spec", "fixtures", type.to_s, name))
end
