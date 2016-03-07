shared_examples_for("a specific machine") do


  context 'statemachine' do
    #   let(:machine) { create(:m_machine) }
    it 'initializes with :available as default state' do
      expect(machine.state).to eq("available")
    end
    describe '#next_steps' do
      it 'returns the keys of the next possible event for the current state' do
        expect(machine.next_steps).to include("claim")
      end
    end
    describe '#claim' do
      it 'responds to #claim ' do
        expect(machine).to respond_to(:claim)
      end
      it 'changes machine user id to current_user' do
        expect{machine.claim!(user)}.to change{machine.user}.from(nil).to(user)
      end
      it 'changes machine state to :empty' do
        machine.claim!(user)
        expect(machine.state).to eq("empty")
      end
    end
    context 'when empty' do
      before(:each) do
        machine.claim!(user)
      end
      describe '#unclaim' do
        it 'responds to #unclaim ' do
          expect(machine).to respond_to(:unclaim)
        end
        it 'changes machine state to :empty' do
          machine.unclaim!
          expect(machine.state).to eq("available")
        end
        it 'changes machine user id to nil' do
          expect{machine.unclaim!}.to change{machine.user}.from(user).to(nil)
        end
      end
      describe '#fill' do
        it 'responds to #fill ' do
          expect(machine).to respond_to(:fill)
        end

        context 'when nil load' do
          it 'changes raises "null weight Error" ' do
            expect { machine.fill! }.to raise_error("Cannot insert an empty load")
          end
        end
        context 'when load too large ' do
          it 'changes raises "Load Weight Error" ' do
            # bigLoad = create(:load, user: user, weight: 50)
            expect { machine.fill!(bigLoad) }.to raise_error("Cannot insert a load heavier than capacity")
          end
        end
        context 'when load will fit ' do
          it 'changes machine state to :unpaid' do
            expect{machine.fill!(load)}.to change{machine.state}.from("empty").to("unpaid")
          end
          it 'reduces machine capacity' do
            expect{machine.fill!(load)}.to change{machine.capacity}.by(-(load.weight))
          end
          it 'assigns machine load' do
            expect{machine.fill!(load)}.to change{machine.load}.from(nil).to(load)
          end
        end
      end
      context 'when unpaid' do
        before(:each) do
          machine.fill!(load)
        end


        describe '#insert_coins' do
          it 'responds to #insert_coins ' do
            expect(machine).to respond_to(:insert_coins)
          end
          it 'changes coins by 0 without args' do
            # puts machine.instance_variables
            expect{machine.insert_coins!}.not_to change{machine.coins}
          end
          it 'changes coins by count' do
            puts machine.coins
            expect{machine.insert_coins!(sufficient_coins)}.to change{machine.coins}.by(sufficient_coins)
          end
          xit 'changes price by count' do
            puts machine.price
            expect{machine.insert_coins!(sufficient_coins)}.to change{machine.price}.by(sufficient_coins)
          end
          it 'changes machine state to ready' do
            expect{machine.insert_coins!(sufficient_coins)}.to change{machine.state}.from("unpaid").to("ready")
          end
        end
        context 'when ready' do
          before(:each) do
            machine.insert_coins!(sufficient_coins)
          end
          describe '#start' do
            it 'responds to #start ' do
              expect(machine).to respond_to(:start)
            end
            it 'changes machine state to :in_progess' do
              expect{machine.start!}.to change{machine.state}.from("ready").to("in_progess")
            end
            it 'changes @end_time' do
              machine.start!
              expect(machine.end_time).not_to be_nil
              # expect{machine.start!}.to change{machine.end_time}.from(nil).to((Time.now + machine.period))
            end
          end
          context 'when in_progess' do
            before(:each) do
              machine.start!
            end
            describe '#end_cycle' do
              it 'responds to #end_cycle ' do
                expect(machine).to respond_to(:end_cycle)
              end
              it 'changes machine state to :in_progess' do
                expect{machine.end_cycle!}.to change{machine.state}.from("in_progess").to("complete")
              end
            end
            context 'when complete' do
              before(:each) do
                machine.end_cycle!
              end
              describe '#remove_clothes' do
                it 'responds to #remove_clothes ' do
                  expect(machine).to respond_to(:remove_clothes)
                end
                it 'changes machine state to :empty' do
                  expect{machine.remove_clothes!}.to change{machine.state}.from("complete").to("empty")
                end
              end
            end
            #           end
            #         end
            #       end
          end
        end
      end
    end
  end
end
