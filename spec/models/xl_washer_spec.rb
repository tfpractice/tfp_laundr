require 'rails_helper'

RSpec.describe XlWasher, type: :model do
  let(:user) { create(:user) }
  let(:xl_washer) { create(:xl_washer) }

  it 'has a name' do
    expect(xl_washer.name).to be_a_kind_of(String)
  end
  
  it 'has a name' do
    expect(xl_washer.name).to be_a_kind_of(String)
  end
  
  
  it 'has an type of "xl_washer"' do
    # puts xl_washer.inspect
    expect(xl_washer.type).to eq("XlWasher")

  end

  context 'SubClass methods' do


    it 'includes the Washer class in ancestor chain' do
      expect(xl_washer.class.ancestors ).to include(Washer)
    end
    describe '#price' do

      it 'has a price method' do
        # puts s_washer.methods.sort
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


    context 'statemachine' do
      it 'initializes with :available as default state' do
        expect(xl_washer.state).to eq("available")
      end
      describe '#claim' do
        it 'responds to #claim ' do
          expect(xl_washer).to respond_to(:claim)
        end
        it 'changes xl_washer user id to current_user' do
          expect{xl_washer.claim!(user)}.to change{xl_washer.user}.from(nil).to(user)
        end
        it 'changes xl_washer state to :empty' do
          xl_washer.claim!(user)
          expect(xl_washer.state).to eq("empty")
        end
      end
      context 'when empty' do
        before(:each) do
          xl_washer.claim!(user)
        end
        describe '#unclaim' do
          it 'responds to #unclaim ' do
            expect(xl_washer).to respond_to(:unclaim)
          end
          it 'changes xl_washer state to :empty' do
            xl_washer.unclaim!
            expect(xl_washer.state).to eq("available")
          end
          it 'changes xl_washer user id to nil' do
            expect{xl_washer.unclaim!}.to change{xl_washer.user}.from(user).to(nil)
          end
        end
        describe '#fill' do
          it 'responds to #fill ' do
            expect(xl_washer).to respond_to(:fill)
          end
          it 'changes xl_washer state to :empty' do

            expect{xl_washer.fill!}.to change{xl_washer.state}.from("empty").to("unpaid")
          end
          context 'when unpaid' do
            before(:each) do
              xl_washer.fill!
            end
            describe '#insert_coins' do
              it 'responds to #insert_coins ' do
                expect(xl_washer).to respond_to(:insert_coins)
              end
              it 'changes coins by 0 without args' do
                # puts xl_washer.instance_variables
                expect{xl_washer.insert_coins!}.not_to change{xl_washer.coins}
              end
              it 'changes coins by count' do
                puts xl_washer.coins
                expect{xl_washer.insert_coins!(3)}.to change{xl_washer.coins}.from(0).to(3)
              end
              it 'changes xl_washer state to ready' do

                expect{xl_washer.insert_coins!}.to change{xl_washer.state}.from("unpaid").to("ready")
              end
            end
            context 'when ready' do
              before(:each) do
                xl_washer.insert_coins!
              end
              describe '#start' do
                it 'responds to #start ' do
                  expect(xl_washer).to respond_to(:start)
                end
                it 'changes xl_washer state to :in_progess' do

                  expect{xl_washer.start!}.to change{xl_washer.state}.from("ready").to("in_progess")
                end
              end
              context 'when in_progess' do
                before(:each) do
                  xl_washer.start!
                end
                describe '#end_cycle' do
                  it 'responds to #end_cycle ' do
                    expect(xl_washer).to respond_to(:end_cycle)
                  end
                  it 'changes xl_washer state to :in_progess' do

                    expect{xl_washer.end_cycle!}.to change{xl_washer.state}.from("in_progess").to("complete")
                  end
                end
                context 'when complete' do
                  before(:each) do
                    xl_washer.end_cycle!
                  end
                  describe '#remove_clothes' do
                    it 'responds to #remove_clothes ' do
                      expect(xl_washer).to respond_to(:remove_clothes)
                    end
                    it 'changes xl_washer state to :empty' do

                      expect{xl_washer.remove_clothes!}.to change{xl_washer.state}.from("complete").to("empty")
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
