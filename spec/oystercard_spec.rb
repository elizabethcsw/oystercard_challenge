require 'oystercard'

describe Oystercard do

  let(:station) { double :station, name: "Paddington", zone: 1 }
  let(:station1) { double :station1, name: "Paddington", zone: 1 }
  let(:station2) { double :station2, name: "Aldgate", zone: 1 }
  let(:journey) { double :journey }
  let(:journeyslog) { double :journeyslog }

  before do
    subject.instance_variable_set(:@journeys_log, journeyslog)
    # allow(journeyslog).to receive_messages(
    # :journeys => nil
    # )
  end

  context '#balance' do
    it 'initializes with a zero balance' do
      expect(subject.balance).to eq 0
    end

    it 'can top up the balance' do
      subject.top_up(20)
      expect(subject.balance).to eq 20
    end

    it 'can top up the balance' do
      expect { subject.top_up 1 }.to change { subject.balance }.by 1
    end

    it 'raises an error if balance exceeds 90' do
      max_lim = described_class::MAXIMUM_LIMIT
      card = described_class.new
      card.top_up(max_lim)
      expect { card.top_up 100 }.to raise_error "Max balance £#{max_lim} exceeded"
    end
  end

  context 'before entry' do
    before do
      allow(journeyslog).to receive(:start).with(station1)
      allow(journeyslog).to receive(:journeys).and_return([])
      allow(journeyslog).to receive_message_chain(:latest_journey, :in, :name) { 'Paddington' }

    end

    it 'has a default status of not in use' do
      expect(subject.in_journey?).to eq 'not in use'
    end

    it 'cannot be touched in without a minimun balance of £1' do
      # min_bal = described_class::MIN_BAL
      subject.top_up(0.5)
      expect { subject.touch_in(station1) }.to raise_error "Insufficient funds, min requried balance is #{MIN_BAL}"
    end

    it 'can record touch in station' do
      subject.top_up(5)
      # allow(station).to receive(:name).and_return("Paddington")
      # allow(station).to receive(:zone).and_return(1)
      subject.touch_in(station1)
      expect(subject.journeys_log.latest_journey.in.name).to eq("Paddington")
    end
  end

  context 'within entry' do
    before do
      allow(journeyslog).to receive(:start)#.with(station1)
      # allow(journeyslog).to receive(:journeys).and_return([journey])
    end

    it 'is in journey' do
      expect(subject).to respond_to(:in_journey?)
    end

    it 'changes its status to in use after touch in' do
      subject.top_up(2)
      allow(journeyslog).to receive(:journeys).and_return([])
      subject.touch_in(station1)
      allow(journeyslog).to receive(:journeys).and_return([journey])
      allow(journeyslog).to receive_message_chain(:latest_journey, :out){ nil }
      expect(subject.in_journey?).to eq 'in use'
    end
  end

  context 'after touch out' do
    before do
      allow(journeyslog).to receive_message_chain(:latest_journey, :fare) { 2 }
      allow(journeyslog).to receive_messages(
                                :start => true,
                                :finish => true,
                            )
    end

    it 'will reduce the balance by a specified amount' do
      subject.top_up(20)
      # prepare touched_in to return false when touch_in
      allow(journeyslog).to receive(:journeys).and_return([])
      subject.touch_in(station1)
      # prepare touched_out to return false when touch_out
      allow(journeyslog).to receive(:journeys).and_return([journey])
      allow(journeyslog).to receive_message_chain(:latest_journey, :in) { station1 }
      allow(journeyslog).to receive_message_chain(:latest_journey, :out) { nil }
      subject.touch_out(station2)
      expect(subject.balance).to eq 18
    end

    it 'changes its status to not in use after touch out' do
      subject.top_up(5)
      allow(journeyslog).to receive(:journeys).and_return([])
      subject.touch_in(station1)
      allow(journeyslog).to receive(:journeys).and_return([journey])
      allow(journeyslog).to receive_message_chain(:latest_journey, :in) { station1 }
      allow(journeyslog).to receive_message_chain(:latest_journey, :out) { nil }
      subject.touch_out(station2)
      allow(journeyslog).to receive_message_chain(:latest_journey, :out) { station2 }
      expect(subject.in_journey?).to eq 'not in use'
    end

    it 'can deduct the balance when touching out' do
      subject.top_up(5)
      allow(journeyslog).to receive(:journeys).and_return([])
      subject.touch_in(station1)
      expect { subject.touch_out(station2) }.to change { subject.balance }.by(-2)
    end

    it 'records journeys' do
      subject.top_up(5)
      allow(journeyslog).to receive(:journeys).and_return([])
      subject.touch_in(station1)
      allow(journeyslog).to receive(:journeys).and_return([journey])
      allow(journeyslog).to receive_message_chain(:latest_journey, :in) { station1 }
      allow(journeyslog).to receive_message_chain(:latest_journey, :out) { nil }
      subject.touch_out(station2)
      allow(journeyslog).to receive_message_chain(:latest_journey, :out, :name) { "Aldgate" }
      expect(subject.journeys_log.latest_journey.out.name).to eq("Aldgate")
    end
  end

end
