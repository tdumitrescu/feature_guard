# FeatureGuard

Lightweight Redis-based feature-flagging for Ruby apps. Provides a simple syntax for enabling and disabling features, or gradually ramping up and down by enabling features for a percentage of total traffic.

## Installation

Add this line to your application's Gemfile:

    gem 'feature_guard'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install feature_guard

## Usage

Check whether a feature is enabled globally:

```ruby
FeatureGuard.enabled? :my_feature
```

Globally enable or disable a feature:

```ruby
FeatureGuard.enable  :my_feature
FeatureGuard.disable :my_feature
FeatureGuard.toggle  :my_feature
```

Feature names can be strings or symbols. No data setup is necessary; any check for a feature which has never been enabled simply returns false.

For more fine-grained control, set a ramp-up value to decide which percentage of traffic should see the feature:

```ruby
FeatureGuard.set_ramp  :my_feature, 30.5  # 30.5%
FeatureGuard.bump_ramp :my_feature, 12    # 30.5 + 12 = 42.5%
FeatureGuard.bump_ramp :my_feature        # 42.5 + 10 = 52.5%

FeatureGuard.ramp_val :my_feature # 52.5
```

`.set_ramp` sets the ramp-up value; `.bump_ramp` increments or decrements it by a given value (defaults to 10.0). Check the current ramp-up value with `.ramp_val`.

Check whether to show the feature at the current ramp-up value:

```ruby
FeatureGuard.allow? :my_feature, user_id
# true for 52.5% of user_id values

FeatureGuard.allow? :my_feature
# true for 52.5% of checks (random)
```

The optional second argument to`.allow?` can be of any type (e.g., user ID or name or even an object). It is hashed with the feature name to create a reproducible numeric value for checking whether to return true or false based on the current ramp-up value. With no second argument, `.allow?` uses a new random value on every call.

## Configuration

Optionally change the Redis client with:

```ruby
FeatureGuard.redis = my_redis_client
```

Setting `FeatureGuard.redis` to `nil` will revert it to a new default instance (`Redis.new`).

## Running tests

    $ bundle exec rspec

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
