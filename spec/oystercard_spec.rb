require 'oystercard'

describe Oystercard do
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
    expect { card.top_up 1 }.to raise_error "Max balance £#{max_lim} exceeded"
  end

  it 'will reduce the balance by a specified amount' do
    subject.top_up(20)
    subject.deduct(5)
    expect(subject.balance).to eq 15
  end
end
