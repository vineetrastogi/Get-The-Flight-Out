require 'date'

class TripsController < ApplicationController

  def index
    # @all_trips = Trip.where("sale_total < ?", params[:sale_total]).order(:sale_total).sample(10)
    # airport_codes =
    # ["PEK","LHR","HND","CDG","FRA","HKG","DXB","CGK","AMS","MAD","BKK","SIN","CAN","PVG","MUC","KUL","FCO","IST","SYD","ICN","DEL","BCN","LGW","YYZ","SHA","BOM","GRU","MNL","CTU","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","PMI","CPH","SVO","KMG","VIE","OSL","JED","BNE","DUS","BOG","MXP","JNB","ARN","MAN","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL"]
    airport_codes = ["PEK","LHR","HND","CDG","FRA"]
    @result = []

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
            "solutions" => 4,
            "refundable" => false
          }
        }.to_json

      @response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyB9sDMOUjCNYYrn4K0A_CxPmEF7v2k741g",
        body: request,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })
      @result << @response

      # consider putthing these methods inside a module
      def find_origin_city(params)
        x = []
        @result[0]['trips']['data']['city'].each { |el| x << el if el.has_value?(params) }
        return x[0]['name']
      end

      def convert_date_to_time(date_time)
        date = Date.parse(date_time)
        date = date.to_s
        time = date_time[11..15]
        date + " at " + time
      end

      def unique_carrier_name
        n = 0
        @result[0]['trips']['data']['carrier'].size.times do
          @carrier = @result[0]['trips']['data']['carrier'][n]['name']
          n += 1
        end
        @carrier
      end

    p "*" * 100
    p @response
    p "*" * 100

    counter = 0
      4.times do
        # if response['trips']['data']['airport']== nil
        #   @no_flight_error = 'No flight found with this search'
        # elsif response['trips']['tripOption'][responses_counter] == nil
        #   @no_flight_error
        # else
          @ticket_price = @result[0]['trips']['tripOption'][counter]['saleTotal'].reverse.chomp('DSU').reverse.to_f
          if @result[0]['trips']['data']['carrier'].size < 4
            m = 0
            n = @result[0]['trips']['data']['carrier'].size
            n.times do
              @carrier = @result[0]['trips']['data']['carrier'][m]['name']
              m += 1
            end
            # @carrier_code = @result[0]['trips']['data']['carrier'][counter]['code']
          # else
          #   unique_carrier_name
          end
          @flight_number = @result[0]['trips']['tripOption'][counter]['slice'][0]['segment'][0]['flight']['number']
          @depart_time = @result[0]['trips']['tripOption'][counter]['slice'][0]['segment'].first['leg'][0]['departureTime']
          @arrival_time = @result[0]['trips']['tripOption'][counter]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
          @duration = @result[0]['trips']['tripOption'][counter]['slice'][0]['duration']
          @origin = find_origin_city(params['origin'])
          # these are null, fix after
          @destination = @result[0]['trips']['data']['city'].first['name']
          @destination_code = @result[0]['trips']['data']['city'].first['name']['code']

      Trip.create(sale_total: @ticket_price, carrier: @carrier, carrier_code: @carrier_code, flight_number: @flight_number, depart_time: convert_date_to_time(@depart_time), arrival_time: convert_date_to_time(@arrival_time), duration: @duration, mileage: nil, origin: @origin, destination: @destination_code)
          counter += 1
        # end
      end


    end
    p "=" * 50
    p @result
    p "=" * 50
    @trips = Trip.all
    render json: @trips
  end
end


# module NecessaryMethod
#   class OriginCity
#     def find_origin_city(params)
#       x = []
#       @result[0]['trips']['data']['city'].each { |el| x << el if el.has_value?(params) }
#       return x[0]['name']
#     end
#   end
# end









