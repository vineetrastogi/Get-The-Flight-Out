class TripsController < ApplicationController

  def index
    # @all_trips = Trip.where("sale_total < ?", params[:sale_total]).order(:sale_total).sample(10)
    # airport_codes =
    # ["PEK","LHR","HND","CDG","FRA","HKG","DXB","CGK","AMS","MAD","BKK","SIN","CAN","PVG","MUC","KUL","FCO","IST","SYD","ICN","DEL","BCN","LGW","YYZ","SHA","BOM","GRU","MNL","CTU","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","PMI","CPH","SVO","KMG","VIE","OSL","JED","BNE","DUS","BOG","MXP","JNB","ARN","MAN","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL"]
    airport_codes = ["PEK","LHR","HND","CDG","FRA"]
    @result = []
    @ticket_price = []
    @carrier = []
    @carrier_code = []
    @flight_number = []
    @depart_time = []
    @arrival_time = []
    @destination = []
    @destination_code = []
    @origin = []
    @duration = []
    @all_objects = []
    # @final_result = []
    # @final_result = {}

    airport_codes.each do |airport|
      # p params
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
            @result << @response

            p '*' * 100
            p @result

            counter = 0
            2.times do
              @ticket_price << @result[0]['trips']['tripOption'][counter]['saleTotal'].reverse.chomp('DSU').reverse.to_f
              @carrier << @result[0]['trips']['data']['carrier'][counter]['name']
              @carrier_code << @result[0]['trips']['data']['carrier'][counter]['code']
              @flight_number << @result[0]['trips']['tripOption'][counter]['slice'][0]['segment'][0]['flight']['number']
              @depart_time << @result[0]['trips']['tripOption'][counter]['slice'][0]['segment'].first['leg'][0]['departureTime']
              @arrival_time << @result[0]['trips']['tripOption'][counter]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
              @destination << @result[0]['trips']['data']['city'].first['name']
              @destination_code << @result[0]['trips']['data']['city'].first['name']['code']
              @origin << find_origin_city(params['origin'])
              @duration << @result[0]['trips']['tripOption'][counter]['slice'][0]['duration']

              counter += 1
            end

            @final_result = {ticket_price: @ticket_price, carrier: @carrier, carrier_code: @carrier_code, flight_number: @flight_number, depart_time: @depart_time, arrival_time: @arrival_time, destination: @destination, destination_code: @destination_code, origin: @origin, duration: @duration}
            @all_objects << @final_result
          end
          render json: @all_objects
        end

        def find_origin_city(params)
          x = []
          @result[0]['trips']['data']['city'].each { |el| x << el if el.has_value?(params) }
          return x[0]['name']
        end



      end











