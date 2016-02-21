require 'rails_helper'

RSpec.describe SWasher, type: :model do
  let(:user) { create(:user) }
  let(:s_washer) { build_stubbed(:s_washer, user: user) }

  it 'has a name' do
    expect(s_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(s_washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
    expect(s_washer.user).to be_a_kind_of(User)

  end
  it 'has an type of "s_washer"' do
  	puts s_washer.type
    expect(s_washer.type).to be_a_kind_of(String)

  end
  context 'included module Small' do


    it 'includes the Small module in the ancestor chain' do
      expect(s_washer.class.included_modules).to include(Small)

    end
    describe '#price' do

      it 'has a price method' do
        expect(s_washer.methods).to include(:price)
      end
      it 'returns 2.00' do
        expect(s_washer.price).to eq(2.00)

      end
    end
    describe '#capacity' do

      it 'has a capacity method' do
        expect(s_washer.methods).to include(:capacity)
      end
      it 'returns 5.0' do
        expect(s_washer.capacity).to eq(5.0)

      end
    end
    describe '#period' do

      it 'has a period method' do
        expect(s_washer.methods).to include(:period)
      end
      it 'returns 20.0' do
        expect(s_washer.period).to eq(20.0)

      end
    end

  end
end
