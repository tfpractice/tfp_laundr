require 'rails_helper'
RSpec.describe Washer, type: :model do
  let(:user) { create(:user) }
  let(:washer) { create(:washer, type: "MWasher") }
  # let(:washer) { create(:m_washer) }
  let(:load) { create(:load, user: user, weight: 5) }
  # before(:each  ) do
  #   washer.becomes(MWasher)
  # end
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
      it 'returns nil for STI superclass' do
        # washer.reload
        # puts washer.class
        # puts washer
        # puts washer.instance_variables.sort
        expect(washer.price).to be(nil)
        # expect {washer.price}.to raise_error(RuntimeError, "Subclass responsibility")
      end
    end
    describe '#capacity' do
      it 'has a capacity method' do
        expect(washer.methods).to include(:capacity)
      end
      it 'returns the subclass capacity attribute' do

        expect(washer.capacity).to be(nil)
      end
      # it 'raises a RuntimeError' do
      #   expect {washer.capacity}.to raise_error(RuntimeError, "Subclass responsibility")
      # end
    end
    describe '#period' do
      it 'has a period method' do
        expect(washer.methods).to include(:period)
      end
      it 'returns the subclass capacity attribute' do

        expect(washer.period).to be(nil)
      end
      # it 'raises a RuntimeError' do
      #   expect {washer.period}.to raise_error(RuntimeError, "Subclass responsibility")
      # end
    end
    describe '#time_remaining' do
      it 'has a time_remaining method' do
        expect(washer.methods).to include(:time_remaining)
      end
      context 'when not in_progess' do
        it 'returns period' do
          expect(washer.time_remaining).to eq(washer.period)
        end
      end
      context 'when in_progess' do

      end
    end
    describe '#end_time' do
      it 'has a end_time method' do
        expect(washer.methods).to include(:end_time)

      end
      context 'when not in_progess' do
        it 'retuns nil' do
          expect(washer.end_time).to eq(nil)

        end

      end
      context 'when in_progess' do
        it 'sets the end time' do
          m_washer = create(:m_washer)
          m_washer.claim!(user)
          m_washer.capacity=20
          m_washer.fill!(load)
          m_washer.insert_coins!(m_washer.price)
          m_washer.start!
          puts m_washer.end_time.sec
          puts m_washer.end_time.sec
          puts m_washer.end_time.sec
          # expect(m_washer.end_time.sec).to eq(expect(subject).to be_a_kind_of(klass)59)
          expect(m_washer.end_time).to be_a_kind_of(Time)

        end
      end
    end

    describe '#coins' do
      it 'has a coins attribute' do


        expect(washer).to respond_to(:coins)

      end
      it 'initializes with 0 coins' do


        expect(washer.coins).to be(0)
      end
    end






    context 'statemachine' do
      let(:washer) { create(:m_washer) }
      it 'initializes with :available as default state' do
        expect(washer.state).to eq("available")
      end
      describe '#next_steps' do
        it 'returns the keys of the next possible event for the current state' do
          expect(washer.next_steps).to include("claim")
        end
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
          context 'when nil load' do
            it 'changes raises "null weight Error" ' do
              expect { washer.fill! }.to raise_error("Cannot insert an empty load")
            end
          end
          context 'when load too large ' do
            it 'changes raises "Load Weight Error" ' do
              bigLoad = create(:load, user: user, weight: 50)
              expect { washer.fill!(bigLoad) }.to raise_error("Cannot insert a load heavier than capacity")
            end

          end
          context 'when load will fit ' do
            it 'changes washer state to :unpaid' do
              washer.capacity=20

              expect{washer.fill!(load)}.to change{washer.state}.from("empty").to("unpaid")
            end
            it 'reduces washer capacity' do
              washer.capacity=20
              expect{washer.fill!(load)}.to change{washer.capacity}.from(20).to(15)
            end
            it 'assigns washer load' do
              washer.capacity=20
              expect{washer.fill!(load)}.to change{washer.load}.from(nil).to(load)
            end
          end

          # it 'changes washer state to :empty' do

          #   expect{washer.fill!}.to change{washer.state}.from("empty").to("unpaid")
          # end
          context 'when unpaid' do
            before(:each) do
              washer.capacity=20
              washer.fill!(load)
            end
            describe '#insert_coins' do
              it 'responds to #insert_coins ' do
                expect(washer).to respond_to(:insert_coins)
              end
              it 'changes coins by 0 without args' do
                # puts washer.instance_variables
                expect{washer.insert_coins!}.not_to change{washer.coins}
              end
              it 'changes coins by count' do
                puts washer.coins
                expect{washer.insert_coins!(3)}.to change{washer.coins}.from(0).to(3)
              end
              it 'changes price by count' do
                puts washer.price
                expect{washer.insert_coins!(3)}.to change{washer.coins}.from(0).to(3)
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
                it 'changes @end_time' do
                  washer.start!
                  expect(washer.end_time).not_to be_nil
                  # expect{washer.start!}.to change{washer.end_time}.from(nil).to((Time.now + washer.period))
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
