shared_examples_for('a machine controller') do
#   describe 'MachineController' do
#     it 'includes the MachineController Module from concerns' do
#       # puts controller.class.included_modules
#       expect(controller.class.included_modules).to include(MachineController)
#     end
#     describe 'PATCH #claim' do
#       it 'sets washer state to empty' do
#         patch :claim, id: washer
#         # {:id => washer.to_param, :washer => new_attributes}, valid_session
#         # expect {
#         #   patch :claim, id: washer
#         # }.to change(washer, :state)
#         washer.reload
#         expect(washer.state).to eq("empty")
#       end
#       it 'sets washer user to current_user' do
#         patch :claim, id: washer
#         # {:id => washer.to_param, :washer => new_attributes}, valid_session
#         # expect {
#         #   patch :claim, id: washer
#         # }.to change(washer, :state)
#         washer.reload
#         expect(washer.user).to eq(user)
#       end
#       it "redirects to the washers list" do
#         # washer = Washer.create! valid_attributes
#         patch :claim, id: washer
#         # delete :destroy, {:id => washer.to_param}, valid_session
#         expect(response).to redirect_to(washer)
#       end
#     end
#     context 'when claimed' do
#       before(:each) do
#         patch :claim, id: washer
#       end
#       describe 'PATCH #unclaim' do
#         it 'sets washer state to available' do
#           patch :unclaim, id: washer
#           washer.reload
#           expect(washer.state).to eq("available")
#         end
#         it 'sets washer user to nil' do
#           patch :unclaim, id: washer
#           washer.reload
#           expect(washer.user).to eq(nil)
#         end
#         it "redirects to the washers list" do
#           patch :unclaim, id: washer
#           # delete :destroy, {:id => washer.to_param}, valid_session
#           expect(response).to redirect_to(washer)
#         end
#       end
#       describe 'PATCH #fill' do
#         it 'sets washer state to unpaid' do
#           # washer = create(:m_washer)
#           # puts washer.instance_variables
#           # puts "washer capacity#{washer.capacity}"
#           # puts "loadweidght#{load.weight}"
#           patch :fill, id: washer, load: load
#           washer.reload
#           expect(washer.state).to eq("unpaid")
#         end
#         it "redirects to the washers list" do
#           patch :fill, id: washer, load: load
#           # delete :destroy, {:id => washer.to_param}, valid_session
#           expect(response).to redirect_to(washer)
#         end
#       end
#       context 'when unpaid' do
#         before(:each) do
#           patch :fill, id: washer, load: load
#         end
#         describe 'insert_coins' do
#           it 'sets washer state to ready' do
#             # puts "washer.coins_before#{washer.coins}"
#             patch :insert_coins, id: washer, count: 12
#             washer.reload
#             # puts "washer.coins_after#{washer.coins}"
#             expect(washer.state).to eq("ready")
#           end
#           it "redirects to the washers list" do
#             patch :insert_coins, id: washer, count: 12
#             # delete :destroy, {:id => washer.to_param}, valid_session
#             expect(response).to redirect_to(washer)
#           end
#         end
#         context 'when ready' do
#           before(:each) do
#             patch :insert_coins, id: washer, count: 12
#           end
#           describe 'start' do
#             it 'sets washer state to complete' do
#               patch :start, id: washer
#               washer.reload
#               expect(washer.state).to eq("complete")
#             end
#             it "redirects to the washers list" do
#               patch :start, id: washer
#               # delete :destroy, {:id => washer.to_param}, valid_session
#               expect(response).to redirect_to(washer)
#             end
#           end
#           context 'when complete' do
#             before(:each) do
#               patch :start, id: washer
#             end
#             describe 'remove_clothes' do
#               it 'sets washer state to empty' do
#                 patch :remove_clothes, id: washer
#                 washer.reload
#                 expect(washer.state).to eq("empty")
#               end
#               it "redirects to the washers list" do
#                 patch :remove_clothes, id: washer
#                 # delete :destroy, {:id => washer.to_param}, valid_session
#                 expect(response).to redirect_to(washer)
#               end
#             end
#           end
#         end
#       end
#     end
#   end
end
