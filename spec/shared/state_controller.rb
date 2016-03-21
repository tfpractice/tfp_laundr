shared_examples_for('a state controller') do
  describe 'MachineController' do
    before(:each) do
      sign_in user
      # machine
      # machine.hard_reset

      # puts Thread.list
    end
    # after(:each) do
    # machine.hard_reset
    # end
    it 'includes the MachineController Module from concerns' do
      expect(controller.class.included_modules).to include(MachineController)
    end
    fdescribe 'PATCH #hard_reset' do
      it 'sets coins to 0' do
        patch :hard_reset, id: machine
        # machine.hard_reset
        expect(machine.coins).to eq(0)
      end
      it 'sets user to nil' do
        patch :hard_reset, id: machine
        expect(machine.user).to be_nil
      end
      it 'sets load to nil' do
        patch :hard_reset, id: machine
        expect(machine.load).to be_nil
      end
      it 'sets state to available' do
        patch :hard_reset, id: machine
        expect(machine.state).to eq("available")
      end

    end
    describe 'PATCH #claim' do
      it 'sets machine state to empty' do
        patch :claim, id: machine
        machine.reload
        expect(machine.state).to eq("empty")
      end
      it 'sets machine user to current_user' do
        patch :claim, id: machine
        machine.reload
        expect(machine.user).to eq(user)
      end
      it "redirects to the machines list" do
        patch :claim, id: machine
        expect(response).to redirect_to(machine)
      end
    end
    context 'when empty(claimed)' do
      before(:each) do
        # machine.reload
        # puts "pre-action #{machine.state}"
        patch :claim, id: machine
        #binding.pry
        # machine.reload
        # machine.reload
        # puts "post-action #{machine.state}"
      end
      
      describe 'PATCH #unclaim' do
        after(:each) do
          patch :claim, id: machine
          puts "reclaiming machine"

        end
        it 'sets machine state to available' do
          patch :unclaim, id: machine
          machine.reload
          expect(machine.state).to eq("available")
        end
        it 'sets machine user to nil' do
          patch :unclaim, id: machine
          machine.reload
          expect(machine.user).to eq(nil)
        end
        it "redirects to the machines list" do
          patch :unclaim, id: machine
          expect(response).to redirect_to(machine)
        end
      end
      fdescribe 'PATCH #fill' do
        context 'when machine has no coins' do
          it 'sets machine state to unpaid' do
            # paidmachine.reset_coins
            # patch :claim, id: paidmachine

            patch :fill, id: machine, load: load
            machine.reload
            expect(machine.state).to eq("unpaid")
          end
        end
        context 'when machine has enough coins' do
          it 'changes machine state to ready' do
            patch :claim, id: paidmachine
            patch :fill, id: paidmachine, load: load
            ##binding.pry
            # paidmachine.reload
            # puts machine.state
            patch :insert_coins, id: paidmachine, count: sufficient_coins
            ##binding.pry
            # machine.reload
            # puts machine.state
            patch :remove_clothes, id: paidmachine
            ##binding.pry
            # machine.reload
            # puts machine.state
            patch :fill, id: paidmachine, load: load
            ##binding.pry
            # puts paidmachine.state
            # paidmachine.reload
            puts paidmachine.state
            expect(assigns(:machine).state).to eq("ready")
          end
        end
        it "redirects to the machines list" do
          patch :fill, id: machine, load: load
          machine.reload
          expect(response).to redirect_to(machine)
        end
      end
      context 'when unpaid' do
        before(:each) do
          # machine.reload
          #         puts "pre-action #{machine.state}"
          patch :fill, id: machine, load: load
          # machine.state = "unpaid"
          # machine.reload
          #         puts "post-action #{machine.state}"
          #binding.pry

          puts machine.coins
          # machine.reload
        end
        # after(:each) do
        # puts "postrequest machine state"
        # puts machine.state

        # machine.reload

        # puts machine.state

        # end
        describe 'insert_coins' do
          it "changes machine coin count " do
            patch :insert_coins, id: machine, count: 3
            machine.reload
            expect(machine.coins).to eq(3)
          end
          it 'sets machine state to ready' do
            patch :insert_coins, id: machine, count: sufficient_coins
            machine.reload
            expect(machine.state).to eq("ready")
          end
          it "redirects to the machines list" do
            patch :insert_coins, id: machine, count: sufficient_coins
            machine.reload

            expect(response).to redirect_to(machine)
          end
        end
        context 'when ready' do
          before(:each) do
            # machine.reload
            # puts "pre-action #{machine.state}"
            patch :insert_coins, id: machine, count: sufficient_coins
            #binding.pry
            # machine.reload
            # puts "post-action #{machine.state}"
            # puts machine.state
            # puts machine.coins
          end
          describe 'start' do
            it 'sets machine state to in_progress' do
              patch :start, id: machine
              # machine.reload
              expect(assigns(:machine).state).to eq("in_progress")
            end
            it "redirects to the machines list" do
              patch :start, id: machine
              expect(response).to redirect_to(machine)
            end
          end
          context 'when complete' do
            before(:each) do
              # machine.reload
              # puts "pre-action #{machine.state}"
              patch :start, id: machine
              # machine.reload
              #binding.pry
              # puts "post-action #{machine.state}"
              machine.reload
              machine.end_cycle!
            end
            describe 'remove_clothes' do
              it 'sets machine state to empty' do
                # machine.end_cycle!
                patch :remove_clothes, id: machine
                machine.reload
                expect(machine.state).to eq("empty")
              end
              it "redirects to the machines list" do
                patch :remove_clothes, id: machine
                expect(response).to redirect_to(machine)
              end
            end
          end
        end
      end
    end
  end
end
