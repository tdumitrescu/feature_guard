require "redis" unless defined? Redis

require "feature_guard/version"
require "feature_guard/guard"

module FeatureGuard
  class << self
    attr_writer :redis

    def redis
      @redis ||= Redis.new
    end

    [:allow?, :bump_ramp, :disable, :enable, :flags, :toggle, :enabled?, :ramps, :ramp_val, :set_ramp].each do |mname|
      define_method(mname) do |key, *args|
        Guard.new(key).send(mname, *args)
      end
    end
  end
end
