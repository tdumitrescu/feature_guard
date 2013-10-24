require "spec_helper"

describe FeatureGuard do
  let(:feature) { :some_feature_name }

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
