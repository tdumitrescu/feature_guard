module FeatureGuard; class Guard
  attr_reader :feature_name

  def initialize(_feature_name)
    @feature_name = _feature_name
  end

  # binary flag methods (enabled/disabled)
  def disable
    redis.hset(flags_hkey, feature_name, 0)
  end

  def enable
    redis.hset(flags_hkey, feature_name, 1)
  end

  def enabled?
    redis.hget(flags_hkey, feature_name).tap { |v| return (!v.nil? && v.to_i > 0) }
  rescue
    false
  end

  def toggle
    enabled? ? disable : enable
  end

  # ramp methods (0.0 .. 100.0)
  def allow?(val = nil)
    val = val.nil? ? random_val : hashed_val(val)
    val < ramp_val
  end

  def bump_ramp(amount = 10.0)
    set_ramp(ramp_val + amount)
  end

  def ramp_val
    redis.hget(ramps_hkey, feature_name).to_f
  end

  def set_ramp(new_val)
    new_val = new_val.to_f
    new_val = 100.0 if new_val > 100.0
    new_val = 0.0   if new_val < 0.0

    redis.hset(ramps_hkey, feature_name, new_val)
    new_val
  end

  def flags
    redis.hgetall(flags_hkey)
  end

  def ramps
    redis.hgetall(ramps_hkey)
  end

  private

  def hashed_val(s)
    (Digest::MD5.hexdigest("#{feature_name}_#{s}").to_i(16) % 10000).to_f / 100.0
  end

  def random_val
    rand * 100.0
  end

  def redis
    FeatureGuard.redis
  end

  def flags_hkey
    "featureguard_flags"
  end

  def ramps_hkey
    "featureguard_ramps"
  end
end; end
