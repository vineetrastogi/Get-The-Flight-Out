Dotenv::Railtie.load
class TripsController < ApplicationController

  def index
    airport_codes =  %w(LAX SEA AUS BWI BOS CLT MDW ORD CVG CLE )
      # AUS BWI BOS CLT MDW ORD CVG CLE CMH DFW DEN DTW FLL RSW BDL HNL IAH HOU IND MCI LAS LAX MEM MIA MSP BNA MSY JFK LGA EWR OAK ONT MCO PHL PHX PIT PDX RDU SMF SLC SAT SAN SJC SNA SEA STL TPA IAD DCA)
    original_airport_codes = airport_codes.clone
    airport_codes.delete(params['origin'])

    airport_codes.each do |airport|
      # p "THIS IS THE AIRPORT => #{airport}"
      request = {
        "request" => {
          "maxPrice" => "USD" + params['sale_total'],
          "slice" => [
            {
              "origin" => params['origin'],
              "destination" => airport,
              "date" => params['depart_time']
              # "maxStops" => 4
            }
            ],
            "passengers" => {
              "adultCount" => 1
              },
              "solutions" => 1,
              "refundable" => false
            }
            }.to_json

        @response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{ENV['GOOGLE_API_TOKEN']}",
        body: request,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

        def find_city(departing_airport_code)
          hash_containing_city_code = @response['trips']['data']['city'].select { |hash| hash.has_value?(find_city_code(departing_airport_code)) }
          return hash_containing_city_code[0]['name']
        end

        def find_city_code(departing_airport_code)
          @response['trips']['data']['airport'].select { |hash| hash.has_value?(departing_airport_code) }[0]['city']
        end


        # while counter < airport_codes.length
        # 2.times do

        counter = 0
          # ERROR HANDLING
          if @response['trips']['data'].size < 2
            @invalid_input = "No flights found with provided inputs. Please consider a different date or budget."
          else
            @duration = @response['trips']['tripOption'][counter]['slice'][0]['duration']
            @depart_time = @response['trips']['tripOption'][counter]['slice'][0]['segment'].first['leg'][0]['departureTime']
            @arrival_time = @response['trips']['tripOption'][counter]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
            @carrier = @response['trips']['data']['carrier'][counter]['name']
            @sale_total = @response['trips']['tripOption'][counter]['saleTotal'].reverse.chomp('DSU').reverse.to_f
            @carrier_code = @response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['carrier']
            @flight_number = @response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['number']
            # # p @mileage =
            @origin = find_city(params['origin'])
            @destination_code = airport
            @destination = find_city(airport)

              # counter += 1
              # end
            # end

            Trip.create(sale_total: @sale_total, carrier: @carrier, carrier_code: @carrier_code, flight_number: @flight_number, depart_time: @depart_time, arrival_time: @arrival_time, duration: @duration, mileage: @mileage, origin: @origin, destination: @destination, destination_code: @destination_code)
          end
        airport_codes = original_airport_codes
    end
    @trips = Trip.all.order(sale_total: 'asc')
    @client_side = {trips: @trips, invalid_input: @invalid_input}
    render json: @client_side
  end
end









