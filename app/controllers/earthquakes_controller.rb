class EarthquakesController < ApplicationController
  respond_to :json

  # GET /earthquakes.json
  def index
    scope = Earthquake.minimal

    scope = scope.magnitude_over(params[:over]) if params[:over]
    scope = scope.on_date(Time.zone.at(params[:on].to_i).to_date) if params[:on]
    scope = scope.since_time(Time.zone.at(params[:since].to_i)) if params[:since]
    if params[:near]
      lat, lng = params[:near].split(?,).map(&:to_f)
      scope = scope.near(lat, lng)
    end

    render json: Oj.dump(scope.for_json) # using Oj directly for performance
  end

end
