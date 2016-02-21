require 'rails_helper'

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

  # This should return the minimal set of attributes required to create a valid
  # Washer. As you add validations to Washer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # WashersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all washers as @washers" do
      washer = Washer.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:washers)).to eq([washer])
    end
  end

  describe "GET #show" do
    it "assigns the requested washer as @washer" do
      washer = Washer.create! valid_attributes
      get :show, {:id => washer.to_param}, valid_session
      expect(assigns(:washer)).to eq(washer)
    end
  end

  describe "GET #new" do
    it "assigns a new washer as @washer" do
      get :new, {}, valid_session
      expect(assigns(:washer)).to be_a_new(Washer)
    end
  end

  describe "GET #edit" do
    it "assigns the requested washer as @washer" do
      washer = Washer.create! valid_attributes
      get :edit, {:id => washer.to_param}, valid_session
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
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested washer" do
        washer = Washer.create! valid_attributes
        put :update, {:id => washer.to_param, :washer => new_attributes}, valid_session
        washer.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested washer as @washer" do
        washer = Washer.create! valid_attributes
        put :update, {:id => washer.to_param, :washer => valid_attributes}, valid_session
        expect(assigns(:washer)).to eq(washer)
      end

      it "redirects to the washer" do
        washer = Washer.create! valid_attributes
        put :update, {:id => washer.to_param, :washer => valid_attributes}, valid_session
        expect(response).to redirect_to(washer)
      end
    end

    context "with invalid params" do
      it "assigns the washer as @washer" do
        washer = Washer.create! valid_attributes
        put :update, {:id => washer.to_param, :washer => invalid_attributes}, valid_session
        expect(assigns(:washer)).to eq(washer)
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