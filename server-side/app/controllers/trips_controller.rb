class TripsController < ApplicationController

  def index
    airport_codes = ["PEK","LHR","HND","CDG","FRA"]

    airport_codes.each do |airport|
      p "THIS IS THE AIRPORT => #{airport}"
      request = {
        "request" => {
          "maxPrice" => "USD" + params['sale_total'],
          "slice" => [
            {
              "origin" => params['origin'],
              "destination" => airport,
              "date" => params['depart_time']
            }
            ],
            "passengers" => {
              "adultCount" => 1
              },
              "solutions" => 2,
              "refundable" => false
            }
            }.to_json

      @response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyB9sDMOUjCNYYrn4K0A_CxPmEF7v2k741g",
        body: request,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

        counter = 0
        2.times do

          # ERROR HANDLING
          # if @response['trips']['data']['airport'] == nil
          #   @error = 'No flight found with this search'
          # elsif @response['trips']['tripOption'][counter] == nil
          #   @error
          # else
          # @depart_time = @response['trips']['tripOption'][counter]['slice'][0]['segment'].first['leg'][0]['departureTime']
          #  @arrival_time = @response['trips']['tripOption'][counter]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
          # p @carrier = @response['trips']['data']['carrier'][counter]['name']
          # @sale_total = @response['trips']['tripOption'][counter]['saleTotal']
          # @carrier_code = @response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['carrier']
        #   # p "CARRIER_CODE => #{@carrier_code}"
        #   # @flight_number = @response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['number']
        #   # p "FLIGHT_NUMBA => #{@flight_number}"
          counter += 1
          # end
        end

      Trip.create(carrier_code: @carrier_code, flight_number: @flight_number)

    end
    p "*" * 200
    p @response

    @trips = Trip.all
    render json: @trips
  end
end









