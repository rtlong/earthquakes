require "spec_helper"

describe EarthquakesController do
  describe "routing" do

    it "routes to #index" do
      get("/earthquakes").should route_to("earthquakes#index")
    end

  end
end


describe 'application' do
  describe "routing" do

    it "does NOT define a root route" do
      get("/").should_not be_routable
    end

  end
end
