require 'rails_helper'
RSpec.describe Washer, type: :model do
  let(:user) { create(:user) }
  let(:washer) { create(:washer) }
  # let(:washer) { create(:washer, user: user) }
  it 'has a name' do
    expect(washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(washer.position).to be_a_kind_of(Numeric)
  end
  describe '#user' do
    it 'responds to :user' do
      expect(washer).to respond_to(:user)
    end
    it 'initializes with a nil user' do
      expect(washer.user).to be nil
    end
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
        it 'changes washer user id to current_user' do
          expect{washer.claim!(user)}.to change{washer.user}.from(nil).to(user)
        end
        it 'changes washer state to :empty' do
          washer.claim!(user)
          expect(washer.state).to eq("empty")
        end
      end
      context 'when empty' do
        before(:each) do
          washer.claim!(user)
        end
        describe '#unclaim' do
          it 'responds to #unclaim ' do
            expect(washer).to respond_to(:unclaim)
          end
          it 'changes washer state to :empty' do
            washer.unclaim!
            expect(washer.state).to eq("available")
          end
          it 'changes washer user id to nil' do
            expect{washer.unclaim!}.to change{washer.user}.from(user).to(nil)
          end
        end
        describe '#fill' do
          it 'responds to #fill ' do
            expect(washer).to respond_to(:fill)
          end
          it 'changes washer state to :empty' do

            expect{washer.fill!}.to change{washer.state}.from("empty").to("unpaid")
          end
          context 'when unpaid' do
            before(:each) do
              washer.fill!
            end
            describe '#insert_coins' do
              it 'responds to #insert_coins ' do
                expect(washer).to respond_to(:insert_coins)
              end
              it 'changes washer state to ready' do

                expect{washer.insert_coins!}.to change{washer.state}.from("unpaid").to("ready")
              end
            end
            context 'when ready' do
              before(:each) do
                washer.insert_coins!
              end
              describe '#start' do
                it 'responds to #start ' do
                  expect(washer).to respond_to(:start)
                end
                it 'changes washer state to :in_progess' do

                  expect{washer.start!}.to change{washer.state}.from("ready").to("in_progess")
                end
              end
              context 'when in_progess' do
                before(:each) do
                  washer.start!
                end
                describe '#end_cycle' do
                  it 'responds to #end_cycle ' do
                    expect(washer).to respond_to(:end_cycle)
                  end
                  it 'changes washer state to :in_progess' do

                    expect{washer.end_cycle!}.to change{washer.state}.from("in_progess").to("complete")
                  end
                end
                context 'when complete' do
                  before(:each) do
                    washer.end_cycle!
                  end
                  describe '#remove_clothes' do
                    it 'responds to #remove_clothes ' do
                      expect(washer).to respond_to(:remove_clothes)
                    end
                    it 'changes washer state to :empty' do

                      expect{washer.remove_clothes!}.to change{washer.state}.from("complete").to("empty")
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
