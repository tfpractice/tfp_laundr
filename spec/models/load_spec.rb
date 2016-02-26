require 'rails_helper'

RSpec.describe Load, type: :model do
  let(:user) { create(:user) }
  let(:washer) { create(:xl_washer) }
  let(:dryer) { create(:dryer) }
  let(:load) { create(:load, user: user) }

  describe 'attributes' do
    it 'has a weight' do
      expect(load.weight).to be_a_kind_of(Numeric)
    end
    it 'has a user' do
      expect(load.user).to be_a_kind_of(User)
    end
    it 'has a default dirty state' do
      expect(load.state).to eq("dirty")
    end

    describe '#machine' do
      it 'defaults machine to nil' do
        expect(load.machine).to be_nil

      end
      it 'has a machine attribute' do
        expect(load).to respond_to(:machine)
      end
    end
    describe '#dry_time' do
      it 'initializes with a dry_time' do
        expect(load.instance_variables).to include(:@dry_time)
      end
      it 'is 5 times the weight' do
        expect(load.dry_time).to eq(5*load.weight)

      end
    end
    describe '#insert' do
      it 'assigns the machine association' do
      	# load.insert(washer)
      	# load.reload
      	# expect(load.machine).to eq(washer)
        expect { load.insert(washer) }.to change{load.machine}.from(nil).to(washer)

      end

    end
    describe '#remove_from_machine' do
      it 'sets the machine associationto nil' do
      	load.insert(washer)
      	puts load.instance_variables
        expect { load.remove_from_machine }.to change{load.machine}.from(washer).to(nil)

      end

    end
  end
end
