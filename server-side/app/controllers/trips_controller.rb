class TripsController < ApplicationController

  def index
    @all_trips = Trip.where("sale_total < ?", params[:sale_total]).order(:sale_total).sample(10)
    render json: @all_trips
  end

end
