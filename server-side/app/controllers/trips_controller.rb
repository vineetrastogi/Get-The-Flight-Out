Dotenv::Railtie.load
require 'data_parser_helper'
require 'typhoeus'

class TripsController < ApplicationController
include DataParserHelper # SEE HELPERS DIRECTORY
  @@all_codes = ["PEK","LHR","HND","CDG","FRA","HKG","DXB","CGK","AMS","MAD","BKK","SIN","CAN","PVG","MUC","KUL","FCO","IST","SYD","ICN","DEL","BCN","LGW","YYZ","SHA","BOM","GRU","MNL","CTU","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","PMI","CPH","SVO","KMG","VIE","OSL","JED","BNE","DUS","BOG","MXP","JNB","ARN","MAN","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL", "ATL", "ANC", "AUS", "BWI", "BOS", "CLT", "MDW", "ORD", "CVG", "CLE", "CMH", "DFW", "DEN", "DTW", "FLL", "RSW", "BDL", "HNL", "IAH", "HOU", "IND", "MCI", "LAS", "LAX", "MEM", "MIA", "MSP", "BNA", "MSY", "JFK", "LGA", "EWR", "OAK", "ONT", "MCO", "PHL", "PHX", "PIT", "PDX", "RDU", "SMF", "SLC", "SAT", "SAN", "SJC", "SNA", "SEA", "STL", "TPA", "IAD", "DCA"]
  def index
    airport_codes =  @@all_codes.sample(9)
    original_airport_codes = airport_codes.clone
    airport_codes.delete(params['origin'])
    @request_array = []

    @hydra = Typhoeus::Hydra.new
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

      request_hydra = Typhoeus::Request.new("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{ENV['GOOGLE_API_TOKEN']}", method: :post, body: request, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }, followlocation: true)
      @request_array << request_hydra
      @hydra.queue(request_hydra)

      airport_codes = original_airport_codes
    end

    @hydra.run
    @request_array.each do |request|
    p '*' * 100
    p final_response = JSON.parse(request.response.body)
        # ERROR HANDLING: Ensuring that api_call is returning a response with respect to the user's input
        if final_response['trips']['data'].size < 2
          @invalid_input = "No flights found with provided inputs. Please consider a different date or budget."
        else
          duration = final_response['trips']['tripOption'][0]['slice'][0]['duration']
          depart_time = final_response['trips']['tripOption'][0]['slice'][0]['segment'].first['leg'][0]['departureTime']
          arrival_time = final_response['trips']['tripOption'][0]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
          carrier = final_response['trips']['data']['carrier'][0]['name']
          sale_total = final_response['trips']['tripOption'][0]['saleTotal'].reverse.chomp('DSU').reverse.to_f
          carrier_code = final_response['trips']['tripOption'][0]['slice'][0]['segment'][0]['flight']['carrier']
          flight_number = final_response['trips']['tripOption'][0]['slice'][0]['segment'][0]['flight']['number']
          origin = find_city(params['origin'], final_response)
          @original_airport = origin # this is necessary to devoid scoping issues. Please see size_of_result_array variable
          destination_code = final_response['trips']['tripOption'][0]['slice'][0]['segment'].last['leg'][0]['destination']
          destination = find_city(destination_code, final_response)

          Trip.create(sale_total: sale_total, carrier: carrier, carrier_code: carrier_code, flight_number: flight_number, depart_time: depart_time, arrival_time: arrival_time, duration: duration, origin: origin, destination_code: destination_code, destination: destination)
        end
    end
    @trips = Trip.last(9) #9 is the size of @request_array
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








