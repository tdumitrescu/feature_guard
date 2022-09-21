require "fakeredis/rspec"
require "feature_guard"

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.order = 'random'

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end
end
