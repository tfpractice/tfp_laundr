require 'rails_helper'
require 'shared/machine'
require 'shared/machine_instance'
require 'shared/washer_instance'

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
    let(:excessive_coins) { 20 }

  end
  it_behaves_like 'a washer instance' do
    let(:washer) { m_washer }
    let(:load) { create(:load, weight: 9 , user: user) }
    let(:bigLoad) { create(:load, weight: 20, user: user) }
    let(:sufficient_coins) { m_washer.price }
    let(:insufficient_coins) { 6 }
    let(:excessive_coins) { 20 }

  end


  describe '#coin_excess?' do
    before(:each) do
      m_washer.claim!(user)

      m_washer.fill!(load)
    end
    it 'checks if quantity coins inserted will exceeds price ' do
      expect(m_washer).to respond_to(:coin_excess?)

    end
    context 'when inserting insufficient coins' do
      it 'returns false' do

        expect(m_washer.coin_excess?(5)).to be(false)
      end

    end
    context 'when inserting excessive coins' do
      it 'retuns true' do
        expect(m_washer.coin_excess?(20)).to be(true)
      end


    end

  end
  it 'has a name' do
    expect(m_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(m_washer.position).to be_a_kind_of(Numeric)
  end
  it 'has an type of "m_washer"' do
    expect(m_washer.type).to be_a_kind_of(String)
  end
  context 'SubClass methods' do
    it 'includes the Washer class in ancestor chain' do
      expect(m_washer.class.ancestors ).to include(Washer)
    end
    describe '#price' do
      it 'has a price method' do
        #
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
