require 'journey'

describe Journey do

  it 'charges the penalty fare' do
    expect(subject.fare).to eq Journey::PENALTY_FARE
  end

  it 'knows if a journey is not complete' do
    expect(subject.complete?).to eq false
  end

  context 'upon exit, if an exit station is given' do
    let(:station1) { double :station, zone: 1}
    let(:station2) { double :station, zone: 2, name: "Paddington", test: "what"}
    subject { described_class.new(station1) }

    before(:each) do
      subject.finish(station2)
    end

    it 'charges the normal fare' do
      expect(subject.fare).to eq Journey::FARE_PER_TRIP
    end

    it 'knows the zone of its exit station' do
      # subject.finish(station2)
      expect(subject.out.zone).to eq 2
    end

    it 'knows the name of its exit station' do
      # subject.finish(station2)
      expect(subject.out.name).to eq "Paddington"
    end

    it 'knows if a journey is complete' do
      expect(subject.complete?).to be true
    end
  end

  context 'upon exit, if no entry station is given' do
    let(:station1) { double "station"}
    # the thing after double does not matter, whether it is "station" or :station

    before(:each) do
      subject.finish(station1)
    end

    it 'charges the default penalty' do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end

    it 'knows that the journey is not complete' do
      expect(subject.complete?).to be false
    end
  end
end
