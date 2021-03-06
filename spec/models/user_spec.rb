require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  let(:admin) { create(:admin) }
  describe 'attributes' do
    it 'has an email address' do
      expect(user.email).to be_a_kind_of(String)
    end
    it 'has an username' do
      expect(user.username).to be_a_kind_of(String)
    end
    it 'has an password' do
      expect(user.password).to be_a_kind_of(String)
    end
    it 'has coins' do
      expect(user.coins).to be_a_kind_of(Numeric)

    end
    it 'has laundry' do
      expect(user.laundry).to be_a_kind_of(Numeric)

    end
    it 'has loads' do
      # expect(user.loads).to be_a_kind_of(Numeric)
      expect(user).to respond_to(:loads)
    end
    describe 'admin' do
      it 'has an admin' do
        expect(user.attributes).to include("admin")
      end
      it 'defaults admin to false' do
        expect(user.admin).to be false
      end

      context 'when admin' do
        it 'returns true' do
          expect(admin.admin).to be true
        end
      end
    end
    describe '#reduce_coins' do
      it 'decrements the users coin count by some amount' do
        expect{user.reduce_coins(3)}.to change{user.coins}.by(-3)
      end

    end
    describe '#increase_coins' do
      it 'decrements the users coin count by some amount' do
        expect{user.increase_coins(3)}.to change{user.coins}.by(3)
      end
    end
    describe '#reset_coins' do
      it 'resets the users coin count to 20' do
        user.increase_coins(3)
        user.reset_coins
        expect(user.coins).to eq(20)
        # expect{user.reset_coins}.to change{user.coins}.by(-3)
      end
    end
    describe 'laundry' do
      it 'sums the total weight of user.loads' do
        puts user.laundry
        prevWeight = user.laundry
        # user.reload
        (1..4).each { |e| create(:load, user: user)  }
        # expb
        puts user.laundry

        # user.calculate_laundry
        expect(user.laundry).to be > prevWeight
        # expect{user.calculate_laundry}.to change{user.laundry}

      end

    end
    describe '#hard_reset' do
      let(:machine) { create(:washer) }
      let(:load) { create(:load, weight:4, user: user) }
      it 'resets user.washers to nil' do
        machine.claim!(user)
        expect{user.hard_reset}.to change{user.washers.length}.from(1).to(0)

      end
      it 'resets user.loads' do

      end

    end

  end

end
