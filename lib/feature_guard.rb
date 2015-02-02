require "redis" unless defined? Redis

require "feature_guard/version"
require "feature_guard/guard"

module FeatureGuard
  class << self
    attr_writer :redis

    def all_flags
      redis.hgetall(flags_hkey).keys.inject({}) { |h, f| h[f] = enabled? f; h }
    end

    def all_ramps
      redis.hgetall(ramps_hkey).keys.inject({}) { |h, f| h[f] = ramp_val f; h }
    end

    def flags_hkey
      "featureguard_flags"
    end

    def ramps_hkey
      "featureguard_ramps"
    end

    def redis
      @redis ||= Redis.new
    end

    [
      :allow?, :bump_ramp, :disable, :enable, :toggle, :enabled?,
      :ramp_val, :set_ramp
    ].each do |mname|
      define_method(mname) do |key, *args|
        Guard.new(key).send(mname, *args)
      end
    end
  end
end
