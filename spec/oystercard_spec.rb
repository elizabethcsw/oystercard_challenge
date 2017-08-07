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
    expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
  end
end
