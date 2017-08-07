require 'oystercard'

describe Oystercard do
  it 'initializes with a zero balance' do
    expect(described_class.new.balance).to eq 0
  end
end
