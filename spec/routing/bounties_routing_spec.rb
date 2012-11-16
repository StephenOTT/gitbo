require "spec_helper"

describe BountiesController do
  describe "routing" do

    it "routes to #index" do
      get("/bounties").should route_to("bounties#index")
    end

    it "routes to #new" do
      get("/bounties/new").should route_to("bounties#new")
    end

    it "routes to #show" do
      get("/bounties/1").should route_to("bounties#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bounties/1/edit").should route_to("bounties#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bounties").should route_to("bounties#create")
    end

    it "routes to #update" do
      put("/bounties/1").should route_to("bounties#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bounties/1").should route_to("bounties#destroy", :id => "1")
    end

  end
end
