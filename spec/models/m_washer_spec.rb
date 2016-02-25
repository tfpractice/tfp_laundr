require 'rails_helper'

RSpec.describe MWasher, type: :model do
  let(:user) { create(:user) }
  let(:m_washer) { create(:m_washer) }

  it 'has a name' do
    expect(m_washer.name).to be_a_kind_of(String)
  end
  it 'has a position' do
    expect(m_washer.position).to be_a_kind_of(Numeric)
  end
  
  it 'has an type of "m_washer"' do
    # puts m_washer.inspect
    expect(m_washer.type).to be_a_kind_of(String)

  end
  context 'SubClass methods' do


    it 'includes the Washer class in ancestor chain' do
      expect(m_washer.class.ancestors ).to include(Washer)
    end
    describe '#price' do

      it 'has a price method' do
        # puts s_washer.methods.sort
        expect(m_washer.methods).to include(:price)
      end
      it 'returns 12' do
        expect(m_washer.price).to eq(12)

      end
    end
    describe '#capacity' do

      it 'has a capacity method' do
        expect(m_washer.methods).to include(:capacity)
      end
      it 'returns 10.0' do
        expect(m_washer.capacity).to eq(10.0)

      end
    end
    describe '#period' do

      it 'has a period method' do
        expect(m_washer.methods).to include(:period)
      end
      it 'returns 30.0' do
        expect(m_washer.period).to eq(30.0)

      end
    end




    context 'statemachine' do
      it 'initializes with :available as default state' do
        expect(m_washer.state).to eq("available")
      end
      describe '#claim' do
        it 'responds to #claim ' do
          expect(m_washer).to respond_to(:claim)
        end
        it 'changes m_washer user id to current_user' do
          expect{m_washer.claim!(user)}.to change{m_washer.user}.from(nil).to(user)
        end
        it 'changes m_washer state to :empty' do
          m_washer.claim!(user)
          expect(m_washer.state).to eq("empty")
        end
      end
      context 'when empty' do
        before(:each) do
          m_washer.claim!(user)
        end
        describe '#unclaim' do
          it 'responds to #unclaim ' do
            expect(m_washer).to respond_to(:unclaim)
          end
          it 'changes m_washer state to :empty' do
            m_washer.unclaim!
            expect(m_washer.state).to eq("available")
          end
          it 'changes m_washer user id to nil' do
            expect{m_washer.unclaim!}.to change{m_washer.user}.from(user).to(nil)
          end
        end
        describe '#fill' do
          it 'responds to #fill ' do
            expect(m_washer).to respond_to(:fill)
          end
          it 'changes m_washer state to :empty' do

            expect{m_washer.fill!}.to change{m_washer.state}.from("empty").to("unpaid")
          end
          context 'when unpaid' do
            before(:each) do
              m_washer.fill!
            end
            describe '#insert_coins' do
              it 'responds to #insert_coins ' do
                expect(m_washer).to respond_to(:insert_coins)
              end
              it 'changes coins by 0 without args' do
                # puts m_washer.instance_variables
                expect{m_washer.insert_coins!}.not_to change{m_washer.coins}
              end
              it 'changes coins by count' do
                puts m_washer.coins
                expect{m_washer.insert_coins!(3)}.to change{m_washer.coins}.from(0).to(3)
              end
              it 'changes m_washer state to ready' do

                expect{m_washer.insert_coins!}.to change{m_washer.state}.from("unpaid").to("ready")
              end
            end
            context 'when ready' do
              before(:each) do
                m_washer.insert_coins!
              end
              describe '#start' do
                it 'responds to #start ' do
                  expect(m_washer).to respond_to(:start)
                end
                it 'changes m_washer state to :in_progess' do

                  expect{m_washer.start!}.to change{m_washer.state}.from("ready").to("in_progess")
                end
              end
              context 'when in_progess' do
                before(:each) do
                  m_washer.start!
                end
                describe '#end_cycle' do
                  it 'responds to #end_cycle ' do
                    expect(m_washer).to respond_to(:end_cycle)
                  end
                  it 'changes m_washer state to :in_progess' do

                    expect{m_washer.end_cycle!}.to change{m_washer.state}.from("in_progess").to("complete")
                  end
                end
                context 'when complete' do
                  before(:each) do
                    m_washer.end_cycle!
                  end
                  describe '#remove_clothes' do
                    it 'responds to #remove_clothes ' do
                      expect(m_washer).to respond_to(:remove_clothes)
                    end
                    it 'changes m_washer state to :empty' do

                      expect{m_washer.remove_clothes!}.to change{m_washer.state}.from("complete").to("empty")
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
