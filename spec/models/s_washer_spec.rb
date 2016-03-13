require 'rails_helper'
require 'shared/machine'
require 'shared/machine_instance'
require 'shared/washer_instance'


RSpec.describe SWasher, type: :model do
  let(:user) { create(:user) }
  let(:s_washer) { create(:s_washer) }


  it_behaves_like 'a general machine' do

    let(:machine) { s_washer }

  end
  it_behaves_like 'a specific machine' do

    let(:machine) { s_washer }
    let(:load) { create(:load, weight: 4 , user: user) }
    let(:bigLoad) { create(:load, weight: 16, user: user) }
    let(:sufficient_coins) { s_washer.price }
    let(:insufficient_coins) { 2 }

  end

  it_behaves_like 'a washer instance' do
    let(:washer) { s_washer }
    let(:load) { create(:load, weight: 4 , user: user) }
    let(:bigLoad) { create(:load, weight: 20, user: user) }
    let(:sufficient_coins) { s_washer.price }
    let(:insufficient_coins) { 6 }
    let(:excessive_coins) { 20 }
  end

  describe 'SubClass methods' do


    it 'includes the Washer class in ancestor chain' do
      expect(s_washer.class.ancestors ).to include(Washer)
    end
    describe '#price' do

      it 'has a price method' do
        expect(s_washer.methods).to include(:price)
      end
      it 'returns 8' do
        expect(s_washer.price).to eq(8)

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
