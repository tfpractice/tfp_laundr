require 'rails_helper'
require 'shared/machine'
require 'shared/machine_instance'

RSpec.describe MWasher, type: :model do
  let(:user) { create(:user) }
  let(:m_washer) { create(:m_washer) }
  let(:load) { create(:load, user: user, weight: 5) }

  it_behaves_like 'a general machine' do

    let(:machine) { m_washer }

  end
  it_behaves_like 'a specific machine' do

    let(:machine) { m_washer }
    let(:load) { create(:load, weight: 9 , user: user) }
    let(:bigLoad) { create(:load, weight: 20, user: user) }
    let(:sufficient_coins) { m_washer.price }
    let(:insufficient_coins) { 6 }

  end
  it 'has a name' do
    expect(m_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(m_washer.position).to be_a_kind_of(Numeric)
  end

  it 'has an type of "m_washer"' do
    # puts m_washer.inspect
    expect(m_washer.type).to be_a_kind_of(String)

  end
  context 'SubClass methods' do


    it 'includes the Washer class in ancestor chain' do
      expect(m_washer.class.ancestors ).to include(Washer)
    end
    describe '#price' do

      it 'has a price method' do
        # puts s_washer.methods.sort
        expect(m_washer.methods).to include(:price)
      end
      it 'returns 12' do
        expect(m_washer.price).to eq(12)

      end
    end
    describe '#capacity' do

      it 'has a capacity method' do
        expect(m_washer.methods).to include(:capacity)
      end
      it 'returns 10.0' do
        expect(m_washer.capacity).to eq(10.0)

      end
    end
    describe '#period' do

      it 'has a period method' do
        expect(m_washer.methods).to include(:period)
      end
      it 'returns 30.0' do
        expect(m_washer.period).to eq(30.0)

      end
    end



  end

end
