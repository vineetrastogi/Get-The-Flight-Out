Dotenv::Railtie.load
require 'data_parser_helper'
require 'typhoeus'

class TripsController < ApplicationController
# include DataParserHelper # SEE HELPERS DIRECTORY

  def index
    airport_codes =  %w(LAX SFO SEA ATL)
      # AUS BWI BOS CLT MDW ORD CVG CLE CMH DFW DEN DTW FLL RSW BDL HNL IAH HOU IND MCI LAS LAX MEM MIA MSP BNA MSY JFK LGA EWR OAK ONT MCO PHL PHX PIT PDX RDU SMF SLC SAT SAN SJC SNA SEA STL TPA IAD DCA)
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


          def find_city(departing_airport_code, final_response)
            hash_containing_city_code = final_response['trips']['data']['city'].select { |hash| hash.has_value?(find_city_code(departing_airport_code, final_response)) }
            return hash_containing_city_code[0]['name']
          end

          def find_city_code(departing_airport_code, final_response)
            final_response['trips']['data']['airport'].select { |hash| hash.has_value?(departing_airport_code) }[0]['city']
          end

            request_hydra = Typhoeus::Request.new("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyB9sDMOUjCNYYrn4K0A_CxPmEF7v2k741g", method: :post, body: request, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }, followlocation: true)
            @request_array << request_hydra
            @hydra.queue(request_hydra)

            # @response.on_complete do |response|
            #   @parsed_response = JSON.parse(response.body)
            #   p @parsed_response
            # @result_array << @request
            #           counter = 0
            #           # ERROR HANDLING: Ensuring that api_call is returning a response with respect to the user's input
            #           if @parsed_response['trips']['data'].size < 2
            #             @invalid_input = "No flights found with provided inputs. Please consider a different date or budget."
            #           else
            #             @duration = @parsed_response['trips']['tripOption'][counter]['slice'][0]['duration']
            #             @depart_time = @parsed_response['trips']['tripOption'][counter]['slice'][0]['segment'].first['leg'][0]['departureTime']
            #             @arrival_time = @parsed_response['trips']['tripOption'][counter]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
            #             @carrier = @parsed_response['trips']['data']['carrier'][counter]['name']
            #             @sale_total = @parsed_response['trips']['tripOption'][counter]['saleTotal'].reverse.chomp('DSU').reverse.to_f
            #             @carrier_code = @parsed_response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['carrier']
            #             @flight_number = @parsed_response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['number']
            #             @origin = find_city(params['origin'])
            #             @destination_code = airport
            #             @destination = find_city(airport)

            #             Trip.create(sale_total: @sale_total, carrier: @carrier, carrier_code: @carrier_code, flight_number: @flight_number, depart_time: @depart_time, arrival_time: @arrival_time, duration: @duration, mileage: @mileage, origin: @origin, destination: @destination, destination_code: @destination_code)
            #           end
            #   end

        airport_codes = original_airport_codes
    end

    @hydra.run
    @request_array.each do |request|
    final_response = JSON.parse(request.response.body)
                      counter = 0
                      # ERROR HANDLING: Ensuring that api_call is returning a response with respect to the user's input
                      if final_response['trips']['data'].size < 2
                        invalid_input = "No flights found with provided inputs. Please consider a different date or budget."
                      else
                        duration = final_response['trips']['tripOption'][counter]['slice'][0]['duration']
                        depart_time = final_response['trips']['tripOption'][counter]['slice'][0]['segment'].first['leg'][0]['departureTime']
                        arrival_time = final_response['trips']['tripOption'][counter]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
                        carrier = final_response['trips']['data']['carrier'][counter]['name']
                        sale_total = final_response['trips']['tripOption'][counter]['saleTotal'].reverse.chomp('DSU').reverse.to_f
                        carrier_code = final_response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['carrier']
                        flight_number = final_response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['number']
                        origin = find_city(params['origin'], final_response)
                        # destination_code = airport
                        # destination = find_city(airport, final_response)

                        Trip.create(sale_total: sale_total, carrier: carrier, carrier_code: carrier_code, flight_number: flight_number, depart_time: depart_time, arrival_time: arrival_time, duration: duration, origin: origin)
                      end
  end


    @trips = Trip.all
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








