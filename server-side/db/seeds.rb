# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'httparty'
require 'awesome_print'
require 'date'


# airline_codes =
# ["ATL","PEK","LHR","ORD","HND","LAX","CDG","DFW","FRA","HKG","DEN","DXB","CGK","AMS","MAD","BKK","JFK","SIN","CAN","LAS","PVG","PHX","IAH","CLT","MIA","MUC","KUL","FCO","IST","SYD","MCO","ICN","DEL","BCN","LGW","EWR","YYZ","SHA","MSP","SEA","DTW","PHL","BOM","GRU","MNL","CTU","BOS","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","LGA","FLL","IAD","PMI","CPH","SVO","BWI","KMG","VIE","OSL","JED","BNE","SLC","DUS","BOG","MXP","JNB","ARN","MAN","MDW","DCA","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","SAN","TPA","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL"]

airline_codes =
["ATL","PEK","LHR","ORD","HND","LAX"]

# This statement is for later on, once the user types in their origin. It will take their input, and if it matches a string inside of the array, then we cut out the string in the array and continue with the API Call.

# if airline_codes.include?(response['trips']['data']['city'][-1]['name'])
# end

airline_codes.each do |airline_code|

request = {
  "request" => {
    "maxPrice" => "USD500",
    "slice" => [
      {
        "origin" => "SFO",
        "destination"=> airline_code,
        "date"=> "2015-03-13"
      }
      ],
      "passengers"=> {
        "adultCount"=> 1
        },
        "solutions"=> 2,
        "refundable"=> false
      }
      }.to_json

      response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyB9sDMOUjCNYYrn4K0A_CxPmEF7v2k741g",
        body: request,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

      responses_counter = 0
      2.times do
      if response['trips']['data']['airport'] == nil
        puts 'No flight found with this search'
      else
         p sale_total = response['trips']['tripOption'][responses_counter]['saleTotal']
         .reverse.chomp('DSU').reverse.to_f


        # carrier = response['trips']['data']['carrier'][responses_counter]['name']

        # p carrier_code = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['flight']['carrier']

        # p flight_number = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['flight']['number']

        # p departure_time = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg'][0]['departureTime']

        # p arrival_time = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg'][-1]['arrivalTime']

        # # CALCULATING TOTAL DURATION OF FLIGHT
        # total_duration = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg']
        # all_leg_durations = []
        # total_duration.each do |leg|
        #   all_leg_durations << leg['duration']
        # end
        # p total_travel_time = all_leg_durations.reduce(:+)

        # # CALCULATING TOTAL MILEAGE TRAVELED
        # total_mileage = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg']
        # all_leg_mileages = []
        # total_mileage.each do |leg|
        #   all_leg_mileages << leg['mileage']
        # end
        # p total_distance_traveled = all_leg_mileages.reduce(:+)


        # p origin = response['trips']['data']['city'][-1]['name']

        # p destination = response['trips']['data']['city'][0]['name']

        # def convert_date_to_time(date_time)
        #   p date = Date.parse(date_time)
        #   date = date.to_s
        #   time = date_time[11..15]
        #   p date + " at " + time
        # end

        # Trip.create(sale_total: sale_total, carrier: carrier, carrier_code: carrier_code, flight_number: flight_number, depart_time: convert_date_to_time(departure_time), arrival_time: convert_date_to_time(arrival_time), duration: total_travel_time, mileage: total_distance_traveled, origin: origin, destination: destination)

        # ap responses
        # puts '*' * 100
        # p responses
        responses_counter += 1
        p responses_counter
        p '*' * 100
      end
    end
end
