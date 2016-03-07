require 'rails_helper'
require 'shared/machine'
require 'shared/machine_instance'

RSpec.describe XlWasher, type: :model do
  let(:user) { create(:user) }
  let(:xl_washer) { create(:xl_washer) }

  it_behaves_like 'a general machine' do

    let(:machine) { xl_washer }

  end
  it_behaves_like 'a specific machine' do

    let(:machine) { xl_washer }
    let(:load) { create(:load, weight: 15 , user: user) }
    let(:bigLoad) { create(:load, weight: 50, user: user) }
    let(:sufficient_coins) { xl_washer.price }
    let(:insufficient_coins) { 2 }

  end

  it 'has an type of "xl_washer"' do
    expect(xl_washer.type).to eq("XlWasher")

  end

  context 'SubClass methods' do


    it 'includes the Washer class in ancestor chain' do
      expect(xl_washer.class.ancestors ).to include(Washer)
    end
    describe '#price' do

      it 'has a price method' do
        expect(xl_washer.methods).to include(:price)
      end
      it 'returns 16' do
        expect(xl_washer.price).to eq(16)

      end
    end
    describe '#capacity' do

      it 'has a capacity method' do
        expect(xl_washer.methods).to include(:capacity)
      end
      it 'returns 20.0' do
        expect(xl_washer.capacity).to eq(20.0)

      end
    end
    describe '#period' do

      it 'has a period method' do
        expect(xl_washer.methods).to include(:period)
      end
      it 'returns 45.0' do
        expect(xl_washer.period).to eq(45.0)

      end
    end







  end
end
