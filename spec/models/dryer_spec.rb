require 'rails_helper'
require 'shared/machine'
require 'shared/machine_instance'


RSpec.describe Dryer, type: :model do
  let(:user) { create(:user) }
  let(:dryer) { create(:dryer) }
  let(:load) { create(:load, weight: 10 , state: "wet", user: user) }
  it_behaves_like 'a general machine' do

    let(:machine) { dryer }

  end
  it_behaves_like 'a specific machine' do

    let(:machine) { dryer }
    let(:load) { create(:load, weight: 10 , state: "wet", user: user) }
    let(:bigLoad) { create(:load, weight: 16, user: user) }
    let(:sufficient_coins) { 1 }
    let(:insufficient_coins) { 0 }
    let(:excessive_coins) { 20 }

  end




  describe 'Dryer#next_steps' do
    context 'when state is unpaid' do
      before(:each) do
        dryer.claim!(user)
        dryer.fill!(load)

      end
      it 'can receive #insert_coins' do
        expect(dryer.next_steps).to include("insert_coins")

      end
      context 'when state is ready' do
        before(:each) do
          # dryer.claim!(user)
          # dryer.fill!(load)
          dryer.insert_coins!(1)

        end
        it 'can receive #insert_coins' do
          expect(dryer.next_steps).to include("insert_coins")

        end
        fdescribe '#start' do
          context 'when dryer period satisfies load#dry_time' do
            it 'changes load state to dried' do
              dryer.insert_coins!(9)

              dryer.start!
              expect(dryer.load.state).to eq("dried")
            end
          end
          context 'when dryer period doesnt load#dry_time' do
            it 'changes load state to wet' do
              # dryer.insert_coins!(9)
              dryer.start!
              expect(dryer.load.state).to eq("in_dryer")
            end
          end




        end

        context 'when state is in progress' do
          before(:each) do
            dryer.start!
            # dryer.end_cycle!
          end
          it 'can receive #insert_coins' do
            expect(dryer.next_steps).to include("insert_coins")

          end
          context 'when state is complete' do
            before(:each) do
              # dryer.start!
              dryer.end_cycle!
            end
            it 'can receive #insert_coins' do
              expect(dryer.next_steps).to include("insert_coins")
            end
          end
        end
      end


    end
    # it 'returns the keys of the next possible event for the current state' do
    # expect(machine.next_steps).to include("claim")
    # end
  end# end


end
# end
