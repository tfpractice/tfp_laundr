require 'rails_helper'

RSpec.describe LWasher, type: :model do
  let(:user) { create(:user) }
  let(:l_washer) { create(:l_washer) }

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
        # puts s_washer.methods.sort
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


    context 'statemachine' do
      it 'initializes with :available as default state' do
        expect(l_washer.state).to eq("available")
      end
      describe '#claim' do
        it 'responds to #claim ' do
          expect(l_washer).to respond_to(:claim)
        end
        it 'changes l_washer user id to current_user' do
          expect{l_washer.claim!(user)}.to change{l_washer.user}.from(nil).to(user)
        end
        it 'changes l_washer state to :empty' do
          l_washer.claim!(user)
          expect(l_washer.state).to eq("empty")
        end
      end
      context 'when empty' do
        before(:each) do
          l_washer.claim!(user)
        end
        describe '#unclaim' do
          it 'responds to #unclaim ' do
            expect(l_washer).to respond_to(:unclaim)
          end
          it 'changes l_washer state to :empty' do
            l_washer.unclaim!
            expect(l_washer.state).to eq("available")
          end
          it 'changes l_washer user id to nil' do
            expect{l_washer.unclaim!}.to change{l_washer.user}.from(user).to(nil)
          end
        end
        describe '#fill' do
          it 'responds to #fill ' do
            expect(l_washer).to respond_to(:fill)
          end
          it 'changes l_washer state to :empty' do

            expect{l_washer.fill!}.to change{l_washer.state}.from("empty").to("unpaid")
          end
          context 'when unpaid' do
            before(:each) do
              l_washer.fill!
            end
            describe '#insert_coins' do
              it 'responds to #insert_coins ' do
                expect(l_washer).to respond_to(:insert_coins)
              end
              it 'changes coins by 0 without args' do
                # puts l_washer.instance_variables
                expect{l_washer.insert_coins!}.not_to change{l_washer.coins}
              end
              it 'changes coins by count' do
                puts l_washer.coins
                expect{l_washer.insert_coins!(3)}.to change{l_washer.coins}.from(0).to(3)
              end
              it 'changes l_washer state to ready' do

                expect{l_washer.insert_coins!}.to change{l_washer.state}.from("unpaid").to("ready")
              end
            end
            context 'when ready' do
              before(:each) do
                l_washer.insert_coins!
              end
              describe '#start' do
                it 'responds to #start ' do
                  expect(l_washer).to respond_to(:start)
                end
                it 'changes l_washer state to :in_progess' do

                  expect{l_washer.start!}.to change{l_washer.state}.from("ready").to("in_progess")
                end
              end
              context 'when in_progess' do
                before(:each) do
                  l_washer.start!
                end
                describe '#end_cycle' do
                  it 'responds to #end_cycle ' do
                    expect(l_washer).to respond_to(:end_cycle)
                  end
                  it 'changes l_washer state to :in_progess' do

                    expect{l_washer.end_cycle!}.to change{l_washer.state}.from("in_progess").to("complete")
                  end
                end
                context 'when complete' do
                  before(:each) do
                    l_washer.end_cycle!
                  end
                  describe '#remove_clothes' do
                    it 'responds to #remove_clothes ' do
                      expect(l_washer).to respond_to(:remove_clothes)
                    end
                    it 'changes l_washer state to :empty' do

                      expect{l_washer.remove_clothes!}.to change{l_washer.state}.from("complete").to("empty")
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
