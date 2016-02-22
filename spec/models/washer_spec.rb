require 'rails_helper'

RSpec.describe Washer, type: :model do
  let(:user) { create(:user) }
  let(:washer) { create(:washer, user: user) }

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

  context 'statemachine' do
    it 'initializes with :available as default state' do

      expect(washer.state).to eq("available")
    end
    describe '#claim' do
      it 'responds to #claim ' do
        expect(washer).to respond_to(:claim)
      end
      it 'changes washer state to :empty' do
        washer.claim!
        expect(washer.state).to eq("empty")

      end
    end
    describe '#fill' do
      it 'responds to #fill ' do
        expect(washer).to respond_to(:fill)
      end
      it 'changes washer state to :empty' do
        washer.claim!
        washer.fill!
        expect(washer.state).to eq("unpaid")

      end
    end


  end


end
