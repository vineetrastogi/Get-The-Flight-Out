Dotenv::Railtie.load
require 'data_parser_helper'

class TripsController < ApplicationController
include DataParserHelper # SEE HELPERS DIRECTORY

  def index
    airport_codes =  %w(LAX ORD CVG CLE CMH DFW DEN PHX)
      # AUS BWI BOS CLT MDW ORD CVG CLE CMH DFW DEN DTW FLL RSW BDL HNL IAH HOU IND MCI LAS LAX MEM MIA MSP BNA MSY JFK LGA EWR OAK ONT MCO PHL PHX PIT PDX RDU SMF SLC SAT SAN SJC SNA SEA STL TPA IAD DCA)
    original_airport_codes = airport_codes.clone
    airport_codes.delete(params['origin'])

    airport_codes.each do |airport|
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

        p @response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{ENV['GOOGLE_API_TOKEN']}",
        body: request,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
counter = 0
            # ERROR HANDLING: Ensuring that api_call is returning a response with respect to the user's input
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
              @origin = find_city(params['origin'])
              @destination_code = airport
              @destination = find_city(airport)

              Trip.create(sale_total: @sale_total, carrier: @carrier, carrier_code: @carrier_code, flight_number: @flight_number, depart_time: @depart_time, arrival_time: @arrival_time, duration: @duration, mileage: @mileage, origin: @origin, destination: @destination, destination_code: @destination_code)
            end
        airport_codes = original_airport_codes
    end
    @trips = Trip.where(origin: @origin)
    @client_side = {trips: @trips, invalid_input: @invalid_input}
    render json: @client_side
  end
end


# PSEUDOCODE FOR EXTRACTING NECESSARY INFO FOR MULTI-STOP URLs
# Url Format: ;sel=LAXLAS0NK562-LASORD0NK446
  # Where:
    # LAX => Origin
    # LAS => Midway
    # 0
    # NK => Flight code
    # 562 => Flight number
    # - => Separater
    # LAS => Midway
    # ORD => Destination
    # 0
    # NK => Flight code
    # 446 => Flight number

# 1. FIND array size. If > 2 then it's a multi-stop
    # @multi['trips']['data']['city'].size == 3
    # @single['trips']['data']['city'].size == 2








