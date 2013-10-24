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
