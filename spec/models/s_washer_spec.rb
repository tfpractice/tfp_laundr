require 'rails_helper'

RSpec.describe SWasher, type: :model do
  let(:user) { create(:user) }
  let(:s_washer) { create(:s_washer) }

  it 'has a name' do
    expect(s_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(s_washer.position).to be_a_kind_of(Numeric)
  end
  describe '#user' do
    it 'responds to :user' do
      expect(s_washer).to respond_to(:user)
    end
    it 'initializes with a nil user' do
      expect(s_washer.user).to be nil
    end
  end
  it 'has an type of "s_washer"' do
    # puts s_washer.type
    expect(s_washer.type).to be_a_kind_of(String)

  end
  context 'SubClass methods' do


    it 'includes the Washer class in ancestor chain' do
      expect(s_washer.class.ancestors ).to include(Washer)
    end
    describe '#price' do

      it 'has a price method' do
        expect(s_washer.methods).to include(:price)
      end
      it 'returns 2.00' do
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




    context 'statemachine' do
      it 'initializes with :available as default state' do
        expect(s_washer.state).to eq("available")
      end
      describe '#claim' do
        it 'responds to #claim ' do
          expect(s_washer).to respond_to(:claim)
        end
        it 'changes s_washer user id to current_user' do
          expect{s_washer.claim!(user)}.to change{s_washer.user}.from(nil).to(user)
        end
        it 'changes s_washer state to :empty' do
          s_washer.claim!(user)
          expect(s_washer.state).to eq("empty")
        end
      end
      context 'when empty' do
        before(:each) do
          s_washer.claim!(user)
        end
        describe '#unclaim' do
          it 'responds to #unclaim ' do
            expect(s_washer).to respond_to(:unclaim)
          end
          it 'changes s_washer state to :empty' do
            s_washer.unclaim!
            expect(s_washer.state).to eq("available")
          end
          it 'changes s_washer user id to nil' do
            expect{s_washer.unclaim!}.to change{s_washer.user}.from(user).to(nil)
          end
        end
        describe '#fill' do
          it 'responds to #fill ' do
            expect(s_washer).to respond_to(:fill)
          end
          it 'changes s_washer state to :empty' do

            expect{s_washer.fill!}.to change{s_washer.state}.from("empty").to("unpaid")
          end
          context 'when unpaid' do
            before(:each) do
              s_washer.fill!
            end
            describe '#insert_coins' do
              it 'responds to #insert_coins ' do
                expect(s_washer).to respond_to(:insert_coins)
              end
              it 'changes coins by 0 without args' do
                # puts s_washer.instance_variables
                expect{s_washer.insert_coins!}.not_to change{s_washer.coins}
              end
              it 'changes coins by count' do
                # puts s_washer.coins
                expect{s_washer.insert_coins!(3)}.to change{s_washer.coins}.from(0).to(3)
              end
              it 'changes s_washer state to ready' do

                expect{s_washer.insert_coins!}.to change{s_washer.state}.from("unpaid").to("ready")
              end
            end
            context 'when ready' do
              before(:each) do
                s_washer.insert_coins!
              end
              describe '#start' do
                it 'responds to #start ' do
                  expect(s_washer).to respond_to(:start)
                end
                it 'changes s_washer state to :in_progess' do

                  expect{s_washer.start!}.to change{s_washer.state}.from("ready").to("in_progess")
                end
              end
              context 'when in_progess' do
                before(:each) do
                  s_washer.start!
                end
                describe '#end_cycle' do
                  it 'responds to #end_cycle ' do
                    expect(s_washer).to respond_to(:end_cycle)
                  end
                  it 'changes s_washer state to :in_progess' do

                    expect{s_washer.end_cycle!}.to change{s_washer.state}.from("in_progess").to("complete")
                  end
                end
                context 'when complete' do
                  before(:each) do
                    s_washer.end_cycle!
                  end
                  describe '#remove_clothes' do
                    it 'responds to #remove_clothes ' do
                      expect(s_washer).to respond_to(:remove_clothes)
                    end
                    it 'changes s_washer state to :empty' do

                      expect{s_washer.remove_clothes!}.to change{s_washer.state}.from("complete").to("empty")
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
