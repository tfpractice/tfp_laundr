require 'rails_helper'
require 'shared/state_controller'
=begin
=end
# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.
RSpec.describe WashersController, type: :controller do
  let(:user) { create(:admin) }
  let(:washers) { Washer.all }
  let(:load) { create(:load, user: user) }
  let(:washer) { create(:washer, type: "MWasher")}
  let(:sufficient_coins){12}
  let(:insufficient_coins) { 3 }
  let(:excessive_coins) { 20 }
  let(:valid_attributes) {
    attributes_for(:washer, type: "MWasher")
  }
  let(:invalid_attributes) {
    {type: nil}
  }
  before :each do
    sign_in user
  end
  let(:valid_session) { {} }
  it_behaves_like 'a state controller' do
    let(:user) { create(:admin) }
    let(:machines) { Washer.all }
    let(:machine) { create(:washer)}
    let(:load) { create(:load, user: user) }
    let(:sufficient_coins){12}
    let(:insufficient_coins) { 3 }
    let(:excessive_coins) { 20 }
    let(:valid_attributes) {
      attributes_for(:washer)
    }
  end

  context 'when unpaid' do
    before(:each) do
      patch :claim, id: washer
      patch :fill, id: washer, load: load
    end
    describe 'insert_coins' do


      context "when excessive coins inserted " do
        it 'returns a response error' do
          patch :insert_coins, id: washer, count: excessive_coins
          # puts washer.errors.inspect
          expect(response).not_to be_success
        end
        context "when insufficient coins inserted " do
          it 'returns a response error' do
            patch :insert_coins, id: washer, count: insufficient_coins
            # puts washer.errors.inspect
            expect(response).not_to be_success
          end
        end

      end
    end
  end

  describe "GET #index" do
    it "assigns all washers as @washers" do
      get :index
      skip()
      expect(assigns(:washers)).to eq(washer)
    end
  end
  describe "GET #show" do
    it "assigns the requested washer as @washer" do
      washer = Washer.create! valid_attributes
      get :show, id: washer
      expect(assigns(:washer)).to eq(washer)
    end
  end
  describe "GET #new" do
    it "assigns a new washer as @washer" do
      get :new, attributes_for(:washer)
      expect(assigns(:washer)).to be_a_new(Washer)
    end
  end
  describe "GET #edit" do
    it "assigns the requested washer as @washer" do
      washer = Washer.create! valid_attributes
      get :edit, {:id => washer}, valid_session
      expect(assigns(:washer)).to eq(washer)
    end
  end
  describe "POST #create" do
    context "with valid params" do
      it "creates a new Washer" do
        expect {
          post :create, {:washer => valid_attributes}, valid_session
        }.to change(Washer, :count).by(1)
      end
      it "assigns a newly created washer as @washer" do
        post :create, {:washer => valid_attributes}, valid_session
        expect(assigns(:washer)).to be_a(Washer)
        expect(assigns(:washer)).to be_persisted
      end
      it "redirects to the created washer" do
        post :create, {:washer => valid_attributes}, valid_session
        expect(response).to redirect_to(Washer.last)
      end
    end
    context "with invalid params" do
      it "assigns a newly created but unsaved washer as @washer" do
        post :create, {:washer => invalid_attributes}, valid_session
        expect(assigns(:washer)).to be_a_new(Washer)
      end
      it "re-renders the 'new' template" do
        post :create, {:washer => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end
  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {type: "SWasher"}
      }
      it "updates the requested washer" do
        washer = Washer.create! valid_attributes
        washer = washer.becomes(Washer)
        put :update, {:id => washer.to_param, :washer => new_attributes}, valid_session
        washer.reload
        expect(washer.type).to eq("SWasher")
      end
      it "assigns the requested washer as @washer" do
        washer = Washer.create! valid_attributes
        put :update, {:id => washer, :washer => valid_attributes}, valid_session
        expect(assigns(:washer)).to eq(washer)
      end
      it "redirects to the washer" do
        washer = Washer.create! valid_attributes
        put :update, {:id => washer.to_param, :washer => valid_attributes}, valid_session
        expect(response).to redirect_to(washer.becomes(Washer))
      end
    end
    context "with invalid params" do
      it "assigns the washer as @washer" do
        put :update, {:id => washer.to_param, :washer => invalid_attributes}, valid_session
        assigns(:washer)
        expect((assigns(:washer)).id).to eq(washer.id)
      end
      it "re-renders the 'edit' template" do
        washer = Washer.create! valid_attributes
        put :update, {:id => washer.to_param, :washer => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end
  describe "DELETE #destroy" do
    it "destroys the requested washer" do
      washer = Washer.create! valid_attributes
      expect {
        delete :destroy, {:id => washer.to_param}, valid_session
      }.to change(Washer, :count).by(-1)
    end
    it "redirects to the washers list" do
      washer = Washer.create! valid_attributes
      delete :destroy, {:id => washer.to_param}, valid_session
      expect(response).to redirect_to(washers_url)
    end
  end
end
