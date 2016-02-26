require "rails_helper"

RSpec.describe LoadsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/loads").to route_to("loads#index")
    end

    it "routes to #new" do
      expect(:get => "/loads/new").to route_to("loads#new")
    end

    it "routes to #show" do
      expect(:get => "/loads/1").to route_to("loads#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/loads/1/edit").to route_to("loads#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/loads").to route_to("loads#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/loads/1").to route_to("loads#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/loads/1").to route_to("loads#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/loads/1").to route_to("loads#destroy", :id => "1")
    end

  end
end
