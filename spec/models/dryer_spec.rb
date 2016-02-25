require 'rails_helper'

RSpec.describe Dryer, type: :model do
  let(:user) { create(:user) }
  let(:dryer) { create(:dryer) }

  it 'has a name' do
    expect(dryer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(dryer.position).to be_a_kind_of(Numeric)
  end
   describe '#user' do
    it 'responds to :user' do
      expect(dryer).to respond_to(:user)
    end
    it 'initializes with a nil user' do
      expect(dryer.user).to be nil
    end
  end
  context 'Machine Module' do
    it 'includes the Machine Module in its ancestors' do
      expect(dryer.class.ancestors).to include(Machine)
    end
    describe '#price' do
      it 'has a price method' do
        expect(dryer.methods).to include(:price)
      end
      it 'returns the subclass price attribute' do
        
        expect(dryer.price).to be(3)
      end
    end
    describe '#capacity' do
      it 'has a capacity method' do
        expect(dryer.methods).to include(:capacity)
      end
      it 'returns the subclass capacity attribute' do

        expect(dryer.capacity).to be(15.0)
      end
      # it 'raises a RuntimeError' do
      #   expect {dryer.capacity}.to raise_error(RuntimeError, "Subclass responsibility")
      # end
    end
    describe '#period' do
      it 'has a period method' do
        expect(dryer.methods).to include(:period)
      end
      it 'returns the subclass capacity attribute' do

        expect(dryer.period).to be(0)
      end
      # it 'raises a RuntimeError' do
      #   expect {dryer.period}.to raise_error(RuntimeError, "Subclass responsibility")
      # end
    end

    describe '#coins' do
      it 'has a coins attribute' do


        expect(dryer).to respond_to(:coins)

      end
      it 'initializes with 0 coins' do


        expect(dryer.coins).to be(0)
      end
    end






    context 'statemachine' do
      it 'initializes with :available as default state' do
        expect(dryer.state).to eq("available")
      end
      describe '#claim' do
        it 'responds to #claim ' do
          expect(dryer).to respond_to(:claim)
        end
        it 'changes dryer user id to current_user' do
          expect{dryer.claim!(user)}.to change{dryer.user}.from(nil).to(user)
        end
        it 'changes dryer state to :empty' do
          dryer.claim!(user)
          expect(dryer.state).to eq("empty")
        end
      end
      context 'when empty' do
        before(:each) do
          dryer.claim!(user)
        end
        describe '#unclaim' do
          it 'responds to #unclaim ' do
            expect(dryer).to respond_to(:unclaim)
          end
          it 'changes dryer state to :empty' do
            dryer.unclaim!
            expect(dryer.state).to eq("available")
          end
          it 'changes dryer user id to nil' do
            expect{dryer.unclaim!}.to change{dryer.user}.from(user).to(nil)
          end
        end
        describe '#fill' do
          it 'responds to #fill ' do
            expect(dryer).to respond_to(:fill)
          end
          it 'changes dryer state to :empty' do

            expect{dryer.fill!}.to change{dryer.state}.from("empty").to("unpaid")
          end
          context 'when unpaid' do
            before(:each) do
              dryer.fill!
            end
            describe '#insert_coins' do
              it 'responds to #insert_coins ' do
                expect(dryer).to respond_to(:insert_coins)
              end
              it 'changes coins by 0 without args' do

                expect{dryer.insert_coins!}.not_to change{dryer.coins}
              end
              it 'changes coins by count' do
                puts dryer.coins
                expect{dryer.insert_coins!(3)}.to change{dryer.coins}.from(0).to(3)
              end
              it 'changes dryer state to ready' do

                expect{dryer.insert_coins!}.to change{dryer.state}.from("unpaid").to("ready")
              end
            end
            context 'when ready' do
              before(:each) do
                dryer.insert_coins!
              end
              describe '#start' do
                it 'responds to #start ' do
                  expect(dryer).to respond_to(:start)
                end
                it 'changes dryer state to :in_progess' do

                  expect{dryer.start!}.to change{dryer.state}.from("ready").to("in_progess")
                end
              end
              context 'when in_progess' do
                before(:each) do
                  dryer.start!
                end
                describe '#end_cycle' do
                  it 'responds to #end_cycle ' do
                    expect(dryer).to respond_to(:end_cycle)
                  end
                  it 'changes dryer state to :in_progess' do

                    expect{dryer.end_cycle!}.to change{dryer.state}.from("in_progess").to("complete")
                  end
                end
                context 'when complete' do
                  before(:each) do
                    dryer.end_cycle!
                  end
                  describe '#remove_clothes' do
                    it 'responds to #remove_clothes ' do
                      expect(dryer).to respond_to(:remove_clothes)
                    end
                    it 'changes dryer state to :empty' do

                      expect{dryer.remove_clothes!}.to change{dryer.state}.from("complete").to("empty")
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
