class EarthquakesController < ApplicationController
  respond_to :json

  # GET /earthquakes.json
  def index
    earthquakes = Earthquake.for_serialization.as_hashes
    render json: Oj.dump(earthquakes.to_a, mode: :compat)
  end

end
