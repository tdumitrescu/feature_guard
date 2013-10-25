require "spec_helper"

describe FeatureGuard::Guard do
  let(:feature) { 'exciting new code'}
  let(:guard)   { FeatureGuard::Guard.new(feature) }

  describe '#allow?' do
    before { guard.set_ramp 30.0 }

    context 'when no value is provided' do
      subject { guard.allow? }

      it 'uses a random value' do
        expect(guard).to receive(:random_val).and_return(29.9)
        expect(subject).to be_true
      end
    end

    context 'when a value is provided' do
      subject { guard.allow? 'username_or_id' }

      it 'hashes the value together with the feature name' do
        expect(guard).to receive(:hashed_val).and_return(30.1)
        expect(subject).to be_false
      end
    end
  end

  describe '#bump_ramp' do
    before { guard.set_ramp(5.0) }

    it 'changes the ramp value by the given amount' do
      expect { guard.bump_ramp 14.5 }.to change { guard.ramp_val }.from(5.0).to(19.5)
    end

    it 'defaults to bumping by 10.0' do
      expect { guard.bump_ramp }.to change { guard.ramp_val }.from(5.0).to(15.0)
    end
  end

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

  describe '#set_ramp' do
    let(:new_val) { 51.7 }

    subject { guard.set_ramp new_val }

    it 'sets the ramp value' do
      expect { subject }.to change { guard.ramp_val }.to new_val
    end

    it 'does not set the value above 100.0' do
      guard.set_ramp 190.0
      expect(guard.ramp_val).to eq 100.0
    end

    it 'does not set the value below 0.0' do
      guard.set_ramp -190.0
      expect(guard.ramp_val).to eq 0.0
    end
  end

  describe '#toggle' do
    it 'toggles the feature on or off' do
      expect { guard.toggle }.to change { guard.enabled? }.from(false).to(true)
      expect { guard.toggle }.to change { guard.enabled? }.from(true).to(false)
    end
  end
end
