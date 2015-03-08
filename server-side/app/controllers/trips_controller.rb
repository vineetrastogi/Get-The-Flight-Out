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
p @response
        def find_origin_city(params)
          x = []
          @response['trips']['data']['city'].each { |el| x << el if el.has_value?(params) }
          return x[0]['name']
        end

        # def find_destination_airport_code(airport_code)
        #   x = []
        #   @response['trips']['data']['city'].each { |el| p el x << el if el.has_value?(airport_code) }
        #   p x
        #   return x[0]['code']
        # end

        def find_city(city_name)
          result = []
          @response['trips']['data']['airport'].each { |code| result << code if code.has_value?(city_name)}
          p "=" * 50
          p result
          # return result
        end

        counter = 0
        2.times do

          # ERROR HANDLING
          # if @response['trips']['data']['airport'] == nil
          #   @error = 'No flight found with this search'
          # elsif @response['trips']['tripOption'][counter] == nil
          #   @error
          # else
          p @duration = @response['trips']['tripOption'][counter]['slice'][0]['duration']
          p @depart_time = @response['trips']['tripOption'][counter]['slice'][0]['segment'].first['leg'][0]['departureTime']
           p @arrival_time = @response['trips']['tripOption'][counter]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
          p @carrier = @response['trips']['data']['carrier'][counter]['name']
          p @sale_total = @response['trips']['tripOption'][counter]['saleTotal'].reverse.chomp('DSU').reverse.to_f
          p @carrier_code = @response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['carrier']
          p @flight_number = @response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['number']
          # p @mileage =
          p @origin = find_origin_city(params['origin'])
          p airport
          p '*' * 20
          p find_destination_airport_code(airport)
          p '*' * 20
          p @destination_code = @response['trips']['tripOption'].last['slice'][0]['segment'][0]['leg'][0]['destination']
          p @destination = @response['trips']['data']['airport'][find_city(airport)]['name']

          counter += 1
          # end
        end

      Trip.create(sale_total: @sale_total, carrier: @carrier, carrier_code: @carrier_code, flight_number: @flight_number, depart_time: @depart_time, arrival_time: @arrival_time, duration: @duration, mileage: @mileage, origin: @origin, destination: @destination, destination_code: @destination_code)

    end
    p "*" * 100
    # p @response

    @trips = Trip.all
    render json: @trips
  end
end









