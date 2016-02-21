require "rails_helper"

RSpec.describe WashersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/washers").to route_to("washers#index")
    end

    it "routes to #new" do
      expect(:get => "/washers/new").to route_to("washers#new")
    end

    it "routes to #show" do
      expect(:get => "/washers/1").to route_to("washers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/washers/1/edit").to route_to("washers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/washers").to route_to("washers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/washers/1").to route_to("washers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/washers/1").to route_to("washers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/washers/1").to route_to("washers#destroy", :id => "1")
    end

  end
end
