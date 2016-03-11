shared_examples_for('a state controller') do

  describe 'MachineController' do
    before :each do
      sign_in user
    end
    it 'includes the MachineController Module from concerns' do
      expect(controller.class.included_modules).to include(MachineController)
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
        # machine = Washer.create! valid_attributes
        patch :claim, id: machine
        # delete :destroy, {:id => machine.to_param}, valid_session
        expect(response).to redirect_to(machine)
      end
    end
    context 'when claimed' do
      before(:each) do
        patch :claim, id: machine
      end
      describe 'PATCH #unclaim' do
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
          # delete :destroy, {:id => machine.to_param}, valid_session
          expect(response).to redirect_to(machine)
        end
      end
      describe 'PATCH #fill' do
        it 'sets machine state to unpaid' do
          patch :fill, id: machine, load: load
          machine.reload
          expect(machine.state).to eq("unpaid")
        end
        it "redirects to the machines list" do
          patch :fill, id: machine, load: load
          # delete :destroy, {:id => machine.to_param}, valid_session
          expect(response).to redirect_to(machine)
        end
      end
      context 'when unpaid' do
        before(:each) do
          patch :fill, id: machine, load: load
        end
        describe 'insert_coins' do
          it 'sets machine state to ready' do
            # #puts "machine.coins_before#{machine.coins}"
            patch :insert_coins, id: machine, count: sufficient_coins
            machine.reload
            # #puts "machine.coins_after#{machine.coins}"
            expect(machine.state).to eq("ready")
          end
          it "changes machine coin count " do
            #puts "pre_submit machine.coins #{machine.coins}"
            #puts "pre_submit machine.count #{machine.count}"

            patch :insert_coins, id: machine, count: 3
            #puts controller.params
            #puts "post_patch machine.coins #{machine.coins}"
            #puts "post_patch machine.count #{machine.count}"
            machine.reload
            #puts "post_reload machine.coins_after#{machine.coins}"
            #puts "post_reload machine.count#{machine.count}"
            # expect(machine.coins).to eq(3)
          end

          # context "when sufficient coins inserted " do

          # end
          # context "when insufficient coins inserted" do
          # end
          it "redirects to the machines list" do
            patch :insert_coins, id: machine, count: sufficient_coins
            # delete :destroy, {:id => machine.to_param}, valid_session
            expect(response).to redirect_to(machine)
          end
        end
        context 'when ready' do
          before(:each) do
            patch :insert_coins, id: machine, count: sufficient_coins
          end
          describe 'start' do
            it 'sets machine state to complete' do
              patch :start, id: machine
              machine.reload
              expect(machine.state).to eq("complete")
            end
            it "redirects to the machines list" do
              patch :start, id: machine
              # delete :destroy, {:id => machine.to_param}, valid_session
              expect(response).to redirect_to(machine)
            end
          end
          context 'when complete' do
            before(:each) do
              patch :start, id: machine
            end
            describe 'remove_clothes' do
              it 'sets machine state to empty' do
                patch :remove_clothes, id: machine
                machine.reload
                expect(machine.state).to eq("empty")
              end
              it "redirects to the machines list" do
                patch :remove_clothes, id: machine
                # delete :destroy, {:id => machine.to_param}, valid_session
                expect(response).to redirect_to(machine)
              end
            end
          end
        end
      end
    end
  end
end