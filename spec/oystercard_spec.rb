require 'oystercard'
require 'station'

describe Oystercard do

  # let(:station) { double :station }

  it 'initializes with a zero balance' do
    expect(described_class.new.balance).to eq 0
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

  it 'will reduce the balance by a specified amount' do
    subject.top_up(20)
    station1 = Station.new("Paddington", 1)
    station2 = Station.new("Aldgate", 1)
    subject.touch_in(station1)
    subject.touch_out(station2)
    expect(subject.balance).to eq 18
  end

  it 'is in journey' do
    expect(subject).to respond_to(:in_journey?)
  end

  it 'has a default status of not in use' do
    expect(subject.in_journey?).to eq 'not in use'
  end

  it 'changes its status to in use after touch in' do
    subject.top_up(2)
    station = Station.new("Paddington", 1)
    subject.touch_in(station)
    expect(subject.in_journey?).to eq 'in use'
  end

  it 'changes its status to not in use after touch out' do
    subject.top_up(5)
    station = Station.new("Paddington", 1)
    station2 = Station.new("Aldgate", 1)
    subject.touch_in(station)
    subject.touch_out(station2)
    expect(subject.in_journey?).to eq 'not in use'
  end

  it 'cannot be touched in without a minimun balance of £1' do
    # min_bal = described_class::MIN_BAL
    subject.top_up(0.5)
    station = Station.new("Paddington", 1)
    expect { subject.touch_in(station) }.to raise_error "Insufficient funds, min requried balance is #{MIN_BAL}"
  end

  it 'can deduct the balance when touching out' do
    station1 = Station.new("Paddington", 1)
    station2 = Station.new("Aldgate", 1)
    subject.top_up(5)
    subject.touch_in(station1)
    expect { subject.touch_out(station2) }.to change { subject.balance }.by(-Journey::FARE_PER_TRIP)
  end

  let(:station) { double :station }
  it 'can record touch in station' do
    subject.top_up(5)
    # station = Station.new("Paddington")
    allow(station).to receive(:name).and_return("Paddington")
    allow(station).to receive(:zone).and_return(1)
    subject.touch_in(station)
    expect(subject.journeys_log.last.in.name).to eq("Paddington")
  end

  it 'records journeys' do
    subject.top_up(5)
    station1 = Station.new("Paddington", 1)
    station2 = Station.new("Aldgate", 1)
    subject.touch_in(station1)
    subject.touch_out(station2)
    expect(subject.journeys_log.last.out.name).to eq("Aldgate")
  end

end
