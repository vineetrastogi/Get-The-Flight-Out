Dotenv::Railtie.load
require 'data_parser_helper'
require 'typhoeus'

class TripsController < ApplicationController
include DataParserHelper # SEE HELPERS DIRECTORY: Some necessary methods are executed in DataParserHelper module; i.e. origin & destination.
  @@all_codes = ["PEK","LHR","HND","CDG","FRA","HKG","DXB","CGK","AMS","MAD","BKK","SIN","CAN","PVG","MUC","KUL","FCO","IST","SYD","ICN","DEL","BCN","LGW","YYZ","SHA","BOM","GRU","MNL","CTU","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","PMI","CPH","SVO","KMG","VIE","OSL","JED","BNE","DUS","BOG","MXP","JNB","ARN","MAN","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL","ATL", "ANC", "AUS", "BWI", "BOS", "CLT", "MDW", "ORD", "CVG", "CLE", "CMH", "DFW", "DEN", "DTW", "FLL", "RSW", "BDL", "HNL", "IAH", "HOU", "IND", "MCI", "LAS", "LAX", "MEM", "MIA", "MSP", "BNA", "MSY", "JFK", "LGA", "EWR", "OAK", "ONT", "MCO", "PHL", "PHX", "PIT", "PDX", "RDU", "SLC", "SAT", "SAN", "SJC", "SNA", "SEA", "STL", "TPA", "IAD", "DCA", "MLE"]

  def index
    airport_codes =  @@all_codes.sample(9)
    original_airport_codes = airport_codes.clone # copying airport_codes array in cases where one of the destination airport code is removed becase it matches original airport code.
    airport_codes.delete(params['origin']) # removes airport code from airport_codes if it's identical to user input.
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

      airport_codes = original_airport_codes # airport_codes are reseted to original state
    end
    @hydra.run # making a 'parallel' api call after queueing all api calls

    @request_array.each do |request|
    final_response = JSON.parse(request.response.body)
        # ERROR HANDLING: Ensuring that api_call is returning a response with respect to the user's input
        if final_response['trips']['data'].size < 2 # erroneous data return a response that has 1 object in its data structure
          @invalid_input = "No flights found with provided inputs. Please consider a different date or budget."
        else
          duration = final_response['trips']['tripOption'][0]['slice'][0]['duration']
          depart_time = convert_date_to_time(final_response['trips']['tripOption'][0]['slice'][0]['segment'].first['leg'][0]['departureTime'])
          arrival_time = convert_date_to_time(final_response['trips']['tripOption'][0]['slice'][0]['segment'].last['leg'][0]['arrivalTime'])
          carrier = final_response['trips']['data']['carrier'][0]['name']
          sale_total = final_response['trips']['tripOption'][0]['saleTotal'].reverse.chomp('DSU').reverse.to_i
          carrier_code = final_response['trips']['tripOption'][0]['slice'][0]['segment'][0]['flight']['carrier']
          flight_number = final_response['trips']['tripOption'][0]['slice'][0]['segment'][0]['flight']['number']
          origin = find_city(params['origin'], final_response)
          @original_city = origin # this is necessary to devoid scoping issues. Please see size_of_result_array variable
          destination_code = final_response['trips']['tripOption'][0]['slice'][0]['segment'].last['leg'][0]['destination']
          destination = find_city(destination_code, final_response)
          num_of_stops = final_response['trips']['tripOption'][0]['slice'][0]['segment'].size - 1

          Trip.create(sale_total: sale_total, carrier: carrier, carrier_code: carrier_code, flight_number: flight_number, depart_time: depart_time, arrival_time: arrival_time, duration: duration, origin: origin, destination_code: destination_code, destination: destination, num_of_stop: num_of_stops)
        end
    end

    @trips = Trip.where('sale_total < ?', params['sale_total']).where(origin: @original_city).last(9) # querying objects from the database that is ordered by sale price in ascending order. 9 is the size of @request_array.
    @client_side = {trips: @trips, invalid_input: @invalid_input}
    render json: @client_side
  end
end



