class EarthquakesController < ApplicationController
  respond_to :json

  # GET /earthquakes.json
  def index
    earthquakes = Earthquake.minimal.for_json
    render json: Oj.dump(earthquakes) # using Oj directly for performance
  end

end
