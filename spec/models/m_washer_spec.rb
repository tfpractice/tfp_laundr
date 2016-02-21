require 'rails_helper'

RSpec.describe MWasher, type: :model do
  let(:user) { create(:user) }
  let(:m_washer) { build_stubbed(:m_washer, user: user) }

  it 'has a name' do
    expect(m_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(m_washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an associated user' do
    expect(m_washer.user).to be_a_kind_of(User)

  end
  it 'has an type of "m_washer"' do
    puts m_washer.inspect
    expect(m_washer.type).to be_a_kind_of(String)

  end
  context 'included module Medium' do


    it 'includes the Medium module in the ancestor chain' do
      expect(m_washer.class.included_modules).to include(Medium)

    end
    describe '#price' do

      it 'has a price method' do
        # puts s_washer.methods.sort
        expect(m_washer.methods).to include(:price)
      end
      it 'returns 2.00' do
        expect(m_washer.price).to eq(3.00)

      end
    end
    describe '#capacity' do

      it 'has a capacity method' do
        expect(m_washer.methods).to include(:capacity)
      end
      it 'returns 5.0' do
        expect(m_washer.capacity).to eq(10.0)

      end
    end
    describe '#period' do

      it 'has a period method' do
        expect(m_washer.methods).to include(:period)
      end
      it 'returns 20.0' do
        expect(m_washer.period).to eq(30.0)

      end
    end

  end
end
