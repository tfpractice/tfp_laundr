require 'rails_helper'
RSpec.describe Load, type: :model do
  let(:user) { create(:user) }
  let(:washer) { create(:xl_washer) }
  let(:dryer) { create(:dryer) }
  let(:load) { create(:load, user: user) }
  let(:load2) { create(:load, user: user) }
  let(:user2) { create(:user) }
  let(:load3) { create(:load, user: user2) }
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
   fdescribe '#dry_time' do
      it 'initializes with a dry_time' do
        expect(load.dry_time).to be_a_kind_of(Numeric)
      end
      it 'is 5 times the weight' do
        expect(load.dry_time).to eq(5*load.weight)
      end
    end
  end
  describe '#shared_user?' do
    it 'responds to shared_user?' do
      expect(load).to respond_to(:shared_user?)
    end
    it 'retuns true if two loads share a user' do
      expect(load.shared_user?(load2)).to be true
    end
    it 'retuns false if two do not share a user' do
      expect(load.shared_user?(load3)).to be false
    end
  end
  describe '#same_state?' do
    it 'returns true if two loads share state' do
      expect(load.same_state?(load2)).to be true
    end
    it 'returns false if two loads do not share state' do
      load2.insert!(washer)
      expect(load.same_state?(load2)).to be false
    end
  end
  describe '#merge' do
    let(:load4) { create(:load, user: user) }
    it 'respond_to merge' do
      expect(load).to respond_to(:merge)
    end
    it 'increments load weight by that of second ' do
      expect { load.merge!(load4) }.to change{load.weight}.by(load4.weight)
    end
    it 'does not change load state ' do
      expect { load.merge!(load4) }.not_to change{load.state}
    end
    it 'destroys the second Load ' do
      loadx = create(:load, user: user)
      loady = create(:load, user: user)
      loadz = create(:load, user: user)
      # puts Load.count
      loadx.merge!(loady)
      # puts Load.count
      expect { load.merge!(load4) }.to change{Load.count}.by(1)
    end
    context 'when loads belong to different users' do
      it 'adds a Workflow::TransitionHalted error to errors array' do
        load.merge!(load3)
        expect(load.errors).to include(:weight)
      end
    end
    context 'when loads have different states' do
      it 'adds a Workflow::TransitionHalted error to errors array' do
        load2.insert!(washer)
        load.merge!(load2)
        expect(load.errors).to include(:weight)
      end
    end
    context 'when no load is passed' do
      it 'adds a Workflow::TransitionHalted error to errors array' do
        load.merge!
        expect(load.errors).to include(:weight)
      end
    end
  end
  describe 'stateMachine' do
    context 'when dirty' do
      describe '#next_steps' do
        it 'includes insert_coins' do
          expect(load.next_steps).to include("insert")
        end
        it 'includes insert_coins' do
          expect(load.next_steps).to include("merge")
        end
      end
      describe '#insert' do
        it 'assigns the machine association' do
          expect { load.insert!(washer) }.to change{load.machine}.from(nil).to(washer)
        end
        it 'changes the load state to in_washer' do
          expect { load.insert!(washer) }.to change{load.state}.from("dirty").to("in_washer")
        end
      end
    end
    context 'when in_machine' do
      before(:each) do
        load.insert!(washer)
      end
      describe '#remove_from_machine' do
        it 'sets the machine association to nil' do
          expect { load.remove_from_machine! }.to change{load.machine}.from(washer).to(nil)
        end
        it 'changes the load state to dirty' do
          expect { load.remove_from_machine! }.to change{load.state}.from("in_washer").to("dirty")
        end
      end
      describe '#wash' do
        it 'sets the machine association to nil' do
          skip()
          expect { load.remove_from_machine! }.to change{load.machine}.from(washer).to(nil)
        end
        it 'changes the load state to washed' do
          expect { load.wash! }.to change{load.state}.from("in_washer").to("washed")
        end
        context 'when machine is not  washer' do
          it 'adds a Workflow::TransitionHalted error to errors array' do
            load.remove_from_machine!
            load.insert!(dryer)
            load.wash!
            expect(load.errors).to include(:machine)
          end
        end
      end
      context 'when washed' do
        before(:each) do
          load.wash!
        end
        describe '#remove_from_machine' do
          it 'assigns the machine association' do
            skip()
            expect { load.remove_from_machine! }.to change{load.machine}.from(washer).to(nil)
          end
          it 'changes the load state to wet' do
            expect { load.remove_from_machine!(washer) }.to change{load.state}.from("washed").to("wet")
          end
        end
        context 'when wet' do
          before(:each) do
            load.remove_from_machine!
          end
          describe '#insert' do
            it 'assigns the machine association' do
              skip()
              expect { load.insert!(dryer) }.to change{load.machine}.from(nil).to(dryer)
            end
            it 'changes the load state to in_dryer' do
              expect { load.insert!(dryer) }.to change{load.state}.from("wet").to("in_dryer")
            end
          end
          context 'when in_dryer' do
            before(:each) do
              load.insert!(dryer)
            end
            describe '#remove_from_machine' do
              it 'changes the load state to in_dryer' do
                expect { load.remove_from_machine!(dryer) }.to change{load.state}.from("in_dryer").to("wet")
              end
            end
            describe '#dry' do
              context 'when machine is not a dryer' do
                it 'adds a Workflow::TransitionHalted error to errors array' do
                  load.remove_from_machine!
                  load.insert!(washer)
                  load.dry!
                  expect(load.errors).to include(:machine)
                end
              end
              it 'respondto dry' do
                expect(load).to respond_to(:dry)
              end
              it 'reduces the @dry_time attribute' do
                expect { load.dry!(5) }.to change{load.dry_time}
              end
              fcontext 'when drying for less than dry time' do
                it 'does not change the load state' do
                  insufficient_time = load.dry_time - 4
                  expect { load.dry!(insufficient_time) }.not_to change{load.state}
                end
              end
              context 'when drying for a sufficient time' do
                it 'changes the load state to dried' do
                  expect { load.dry!(load.dry_time) }.to change{load.state}.from("in_dryer").to("dried")
                end
              end
            end
          end
        end
      end
    end
  end
end
# end
