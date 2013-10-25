require "spec_helper"

describe FeatureGuard do
  let(:feature) { :some_feature_name }

  describe 'enabling and disabling a feature' do
    it 'turns the feature on and off in succession' do
      expect {
        FeatureGuard.enable feature
      }.to change {
        FeatureGuard.enabled? feature
      }.from(false).to(true)

      expect {
        FeatureGuard.disable feature
      }.to change {
        FeatureGuard.enabled? feature
      }.from(true).to(false)
    end
  end

  describe 'ramping a feature up and down' do
    let(:user_id) { 5435 }

    it 'allows a percentage of calls to use the feature' do
      expect {
        FeatureGuard.set_ramp feature, 100.0
      }.to change {
        FeatureGuard.allow? feature, user_id
      }.from(false).to(true)

      expect {
        FeatureGuard.set_ramp feature, 0.0
      }.to change {
        FeatureGuard.allow? feature, user_id
      }.from(true).to(false)
    end
  end

  describe '.enabled?' do
    subject { FeatureGuard.enabled? feature }

    context 'for a non-existent flag' do
      it { should be_false }
    end

    context 'when the Redis client blows up or is non-existent' do
      before { FeatureGuard.stub(redis: nil) }

      it { should be_false }
    end
  end
end
