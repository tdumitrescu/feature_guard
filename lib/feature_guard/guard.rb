module FeatureGuard; class Guard
  attr_reader :feature_name

  def initialize(_feature_name)
    @feature_name = _feature_name
  end

  # binary flag methods (enabled/disabled)
  def disable
    redis.set(flag_key, 0)
  end

  def enable
    redis.set(flag_key, 1)
  end

  def enabled?
    redis.get(flag_key).tap { |v| return (!v.nil? && v.to_i > 0) }
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
    redis.get(ramp_key).to_f
  end

  def set_ramp(new_val)
    new_val = new_val.to_f
    new_val = 100.0 if new_val > 100.0
    new_val = 0.0   if new_val < 0.0

    redis.set(ramp_key, new_val)
  end

  private

  def feature_key
    @feature_key ||= feature_name.to_s.split.join('_')
  end

  def flag_key
    @flag_key ||= "fgf_#{feature_key}"
  end

  def ramp_key
    @ramp_key ||= "fgr_#{feature_key}"
  end

  def hashed_val(s)
    (Digest::MD5.hexdigest("#{ramp_key}_#{s}").to_i(16) % 10000).to_f / 100.0
  end

  def random_val
    rand * 100.0
  end

  def redis
    FeatureGuard.redis
  end
end; end
