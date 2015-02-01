require "redis" unless defined? Redis

require "feature_guard/version"
require "feature_guard/guard"

module FeatureGuard
  class << self
    attr_writer :redis

    def all_flags
      redis.hgetall(FeatureGuard.flags_hkey)
    end

    def all_ramps
      redis.hgetall(FeatureGuard.ramps_hkey)
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
