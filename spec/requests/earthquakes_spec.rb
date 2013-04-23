require 'spec_helper'

describe "Earthquakes" do
  describe "GET /earthquakes.json" do
    it "returns a JSON collection with all the Earthquakes, by default" do
      get earthquakes_path, format: :json
      response.status.should be(200)
      pending 'add real testing here'
    end
  end
end
