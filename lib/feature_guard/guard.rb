module FeatureGuard; class Guard
  attr_reader :feature_name

  def initialize(_feature_name)
    @feature_name = _feature_name
  end

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

  def redis
    FeatureGuard.redis
  end
end; end
