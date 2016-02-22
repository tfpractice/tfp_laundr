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


  context 'Machine Module' do
    it 'includes the Machine Module in its ancestors' do
      expect(washer.class.ancestors).to include(Machine)
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
      describe '#unclaim' do
        it 'responds to #unclaim ' do
          expect(washer).to respond_to(:unclaim)
        end
        it 'changes washer state to :empty' do
          washer.claim!
          washer.unclaim!
          expect(washer.state).to eq("available")

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
      describe '#insert_coins' do
        it 'responds to #insert_coins ' do
          expect(washer).to respond_to(:insert_coins)
        end
        it 'changes washer state to :in_progess' do
          washer.claim!
          washer.fill!
          washer.insert_coins!
          expect(washer.state).to eq("ready")

        end
      end
      describe '#start' do
        it 'responds to #start ' do
          expect(washer).to respond_to(:start)
        end
        it 'changes washer state to :in_progess' do
          washer.claim!
          washer.fill!
          washer.insert_coins!
          washer.start!
          expect(washer.state).to eq("in_progess")

        end
      end
      describe '#end_cycle' do
        it 'responds to #end_cycle ' do
          expect(washer).to respond_to(:end_cycle)
        end
        it 'changes washer state to :in_progess' do
          washer.claim!
          washer.fill!
          washer.insert_coins!
          washer.start!

          washer.end_cycle!
          expect(washer.state).to eq("complete")

        end
      end
    end


  end


end
