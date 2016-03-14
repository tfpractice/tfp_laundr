shared_examples_for("a specific machine") do
  describe "methods" do
    describe"#enough_coins?" do
      it "returns false if the machine coins are less than or equal to the price of the machine" do
        expect(machine.enough_coins?).to be(false)
      end
      it "return true of the coins are greater of equal to the price" do
        machine.coins = sufficient_coins
        expect(machine.enough_coins?).to be(true)
      end
    end
    describe '#reset_coins' do
      it 'resets @coins to 0' do
        machine.coins = 2
        expect{machine.reset_coins}.to change{machine.coins}.from(2).to(0)
      end
    end
  end
  context 'statemachine' do
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
          it 'adds a Workflow::TransitionHalted error on load ' do
            machine.fill!(bigLoad)
            expect(machine.errors).to include(:load)
          end
        end
        context 'when load too large ' do
          it 'adds a Workflow::TransitionHalted error on load ' do
            machine.fill!(bigLoad)
            expect(machine.errors).to include(:load)
          end
        end
        context 'when load will fit ' do
          it 'assigns machine load' do
            puts "machine #{machine.inspect}"
            expect{machine.fill!(load)}.to change{machine.load}.from(nil).to(load)
          end
          context ' machine has no coins ' do
            it 'changes machine state to "unpaid"  ' do
              expect{machine.fill!(load)}.to change{machine.state}.from("empty").to("unpaid")
            end
          end
        end
      end
      fdescribe '#next_steps' do
        it 'includes unclaim' do
          expect(machine.next_steps).to include("unclaim")
        end
        it 'includes fill' do
          expect(machine.next_steps).to include("fill")
        end
        it 'returns an array of length 2' do
          expect(machine.next_steps.length).to eq(2)

        end
        context 'if machine has coins' do
          it 'includes return_coins' do
            machine.coins = 1
            expect(machine.next_steps).to include("return_coins")
          end
        end
        context 'if machine has no coins' do
          it 'doesnt allow return_coins' do
            machine.coins = 0
            # machine.return_coins!
            expect(machine.next_steps).not_to include("return_coins")


          end
          it 'does not include return_coins' do
            machine.coins = 0
            expect(machine.next_steps).not_to include("return_coins")
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
          context 'when no coins inserted' do
            it 'changes coins by 0 without args' do
              expect{machine.insert_coins!}.not_to change{machine.coins}
            end
          end
          context 'when insufficient coins inserted' do
            it 'adds a Workflow::TransitionHalted to :coins errors' do
              machine.insert_coins!(insufficient_coins)
              expect(machine.errors).to include(:coins)
            end
            it 'does not change machine state' do
              expect{machine.insert_coins!(insufficient_coins)}.not_to change{machine.state}
            end
          end
          it 'persists the coin change' do
            machine.insert_coins!(insufficient_coins)
            machine.reload
            expect(machine.coins).to eq(insufficient_coins)
          end
          context 'when sufficient_coins inserted' do
            it 'changes machine state from unpaid to ready' do
              expect{machine.insert_coins!(sufficient_coins)}.to change{machine.state}.from("unpaid").to("ready")
            end
          end
        end
        fdescribe '#next_steps' do
          it 'includes insert_coins' do
            expect(machine.next_steps).to include("insert_coins")
          end
          context 'when mahine has coins' do
            it 'includes return_coins' do
              machine.coins = 3
              expect(machine.next_steps).to include("return_coins")
            end
          end

          it 'includes remove_clothes' do
            expect(machine.next_steps).to include("remove_clothes")
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
            end
          end
          describe '#return_coins' do
            it 'sets machine coins to 0' do
              expect{machine.return_coins!}.to change{machine.coins}.from(machine.coins).to(0)
            end
            it 'changes machine state to "unpaid"' do
              expect{machine.return_coins!}.to change{machine.state}.from("ready").to("unpaid")
            end
          end
          describe '#next_steps' do
            it 'includes remove_clothes' do
              expect(machine.next_steps).to include("remove_clothes")
            end
            # it 'includes remove_clothes' do
            # expect(machine.next_steps).to include("remove_clothes")
            # end
            context 'if machine has coins' do
              it 'includes return_coins' do
                machine.coins = 1
                expect(machine.next_steps).to include("return_coins")
              end
            end
            context 'if machine has ennough coins' do
              it 'includes start' do
                machine.coins = machine.price
                expect(machine.next_steps).to include("start")
              end
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
            describe '#next_steps' do
              it 'includes end_cycle' do
                expect(machine.next_steps).to include("end_cycle")
              end
            end
            fcontext 'when complete' do
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
                it 'changes machine load to nil' do
                  expect{machine.remove_clothes!}.to change{machine.load}.from(load).to(nil)
                end
              end
            end
          end
        end
      end
    end
  end
end
