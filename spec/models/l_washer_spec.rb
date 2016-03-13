require 'rails_helper'
require 'shared/machine'
require 'shared/machine_instance'
require 'shared/washer_instance'

RSpec.describe LWasher, type: :model do
  let(:user) { create(:user) }
  let(:l_washer) { create(:l_washer) }



  it_behaves_like 'a general machine' do

    let(:machine) { l_washer }

  end
  it_behaves_like 'a specific machine' do

    let(:machine) { l_washer }
    let(:load) { create(:load, weight: 12 , user: user) }
    let(:bigLoad) { create(:load, weight: 30, user: user) }
    let(:sufficient_coins) { l_washer.price }
    let(:insufficient_coins) { 5 }

  end

   it_behaves_like 'a washer instance' do
    let(:washer) { l_washer }
    let(:load) { create(:load, weight: 9 , user: user) }
    let(:bigLoad) { create(:load, weight: 20, user: user) }
    let(:sufficient_coins) { l_washer.price }
    let(:insufficient_coins) { 6 }
    let(:excessive_coins) { 20 }
  end

  it 'has a name' do
    expect(l_washer.name).to be_a_kind_of(String)
  end


  it 'has an type of "l_washer"' do
    # puts l_washer.inspect
    expect(l_washer.type).to eq("LWasher")

  end

  context 'SubClass methods' do


    it 'includes the Washer class in ancestor chain' do
      expect(l_washer.class.ancestors ).to include(Washer)
    end
    describe '#price' do

      it 'has a price method' do
        # puts l_washer.methods.sort
        expect(l_washer.methods).to include(:price)
      end
      it 'returns 14' do
        expect(l_washer.price).to eq(14)

      end
    end
    describe '#capacity' do

      it 'has a capacity method' do
        expect(l_washer.methods).to include(:capacity)
      end
      it 'returns 15.0' do
        expect(l_washer.capacity).to eq(15.0)

      end
    end
    describe '#period' do

      it 'has a period method' do
        expect(l_washer.methods).to include(:period)
      end
      it 'returns 35.0' do
        expect(l_washer.period).to eq(35.0)

      end
    end



  end
end
