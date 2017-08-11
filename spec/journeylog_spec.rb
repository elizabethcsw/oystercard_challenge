require 'journeylog'
# require 'journey'

describe JourneyLog do

  let (:station1) {double :station1}
  let (:journey) {double :journey}
  let (:journey_c) {double :journey_c}
  subject {described_class.new(journey_c)}

  before do
    allow(journey).to receive(:in).and_return(station1)
    allow(journey_c).to receive(:new).and_return(journey)
    # subject.instance_variable_set(:@journey_class.new, journey)
  end

  context '#start' do
    it 'starts a journey' do
      subject.start(station1)
      expect(subject.journeys.last.in).to eq station1
    end
  end

  context '#current_journey' do
    it 'knows my current incomplete journey' do
      subject.start(station1)
      allow(journey).to receive(:complete?).and_return(false)
      expect(subject.current_journey).to eq journey
  end


end
end
