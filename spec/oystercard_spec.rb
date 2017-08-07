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
    maximum_limit = described_class::MAXIMUM_LIMIT
    subject.top_up(maximum_limit)
    expect { subject.top_up(1) }.to raise_error('Max balance of £90 is exceeded')
  end
end
