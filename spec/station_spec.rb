require 'station'

describe Station do

  subject {described_class.new("Paddington", 1)}

  it 'reads its name' do
    expect(subject.name).to eq "Paddington"
  end

  it 'reads its zone' do
    expect(subject.zone).to eq 1
  end
end
