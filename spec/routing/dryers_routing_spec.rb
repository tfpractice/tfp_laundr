require "rails_helper"

RSpec.describe DryersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/dryers").to route_to("dryers#index")
    end

    it "routes to #new" do
      expect(:get => "/dryers/new").to route_to("dryers#new")
    end

    it "routes to #show" do
      expect(:get => "/dryers/1").to route_to("dryers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/dryers/1/edit").to route_to("dryers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/dryers").to route_to("dryers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/dryers/1").to route_to("dryers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/dryers/1").to route_to("dryers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/dryers/1").to route_to("dryers#destroy", :id => "1")
    end

  end
end
