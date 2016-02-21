require 'rails_helper'

RSpec.describe Washer, type: :model do
  let(:user) { create(:user) }
  let(:washer) { build_stubbed(:washer, user: user) }

  it 'has a name' do
    expect(washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
    expect(washer.user).to be_a_kind_of(User)

  end



  describe '#price' do

    it 'has a price method' do
      expect(washer.methods).to include(:price)
    end
    it 'raises a RuntimeError' do

      expect {washer.price}.to raise_error(RuntimeError, "Subclass responsibility")

    end
  end
  describe '#capacity' do

    it 'has a capacity method' do
      expect(washer.methods).to include(:capacity)
    end
    it 'raises a RuntimeError' do

      expect {washer.capacity}.to raise_error(RuntimeError, "Subclass responsibility")

    end
  end
  describe '#period' do

    it 'has a period method' do
      expect(washer.methods).to include(:period)
    end
    it 'raises a RuntimeError' do

      expect {washer.period}.to raise_error(RuntimeError, "Subclass responsibility")

    end
  end


end
