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
  end
  describe 'stateMachine' do
    describe '#insert' do
      it 'assigns the machine association' do
        expect { load.insert!(washer) }.to change{load.machine}.from(nil).to(washer)
      end
      it 'changes the load state to in_washer' do
        expect { load.insert!(washer) }.to change{load.state}.from("dirty").to("in_washer")
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
                it 'raises an error ' do
                  load.remove_from_machine!
                  load.insert!(washer)
                  expect { load.dry!(5) }.to raise_error()

                end
              end
              it 'reduces the @dry_time attribute' do
                expect { load.dry!(5) }.to change{load.dry_time}.by(-5)
              end
              it 'changes the load state to dried' do
                expect { load.dry!(100) }.to change{load.state}.from("in_dryer").to("dried")
              end
            end
          end
        end
      end
    end
  end
end
# end
