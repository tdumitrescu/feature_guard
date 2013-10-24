require "spec_helper"

describe FeatureGuard::Guard do
  let(:feature) { 'exciting new code'}
  let(:guard)   { FeatureGuard::Guard.new(feature) }

  describe '#enabled?' do
    subject { guard.enabled? }

    context 'for a non-existent flag' do
      it { should be_false }
    end

    context 'for an enabled flag' do
      before { guard.enable }

      it { should be_true }
    end
  end

  describe '#toggle' do
    it 'toggles the feature on or off' do
      expect { guard.toggle }.to change { guard.enabled? }.from(false).to(true)
      expect { guard.toggle }.to change { guard.enabled? }.from(true).to(false)
    end
  end
end
