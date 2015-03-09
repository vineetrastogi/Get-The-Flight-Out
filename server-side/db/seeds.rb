# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# require 'httparty'
# require 'awesome_print'
# # require 'date'


# # airline_codes =
# # ["PEK","LHR","HND","CDG","FRA","HKG","DXB","CGK","AMS","MAD","BKK","SIN","CAN","PVG","MUC","KUL","FCO","IST","SYD","ICN","DEL","BCN","LGW","YYZ","SHA","BOM","GRU","MNL","CTU","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","PMI","CPH","SVO","KMG","VIE","OSL","JED","BNE","DUS","BOG","MXP","JNB","ARN","MAN","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL"]

# # US AIRPORTS
 # %w(ATL ANC AUS BWI BOS CLT MDW ORD CVG CLE CMH DFW DEN DTW FLL RSW BDL HNL IAH HOU IND MCI LAS LAX MEM MIA MSP BNA MSY JFK LGA EWR OAK ONT MCO PHL PHX PIT PDX RDU SMF SLC SAT SAN SJC SNA SEA STL TPA IAD DCA)

# # This statement is for later on, once the user types in their origin. It will take their input, and if it matches a string inside of the array, then we cut out the string in the array and continue with the API Call.

# # if airline_codes.include?(response['trips']['data']['city'][-1]['name'])
# # end

# # airline_codes.each do |airline_code|

#   # request = {
#   #   "request" => {
#   #     "maxPrice" => "USD2000",
#   #     "slice" => [
#   #       {
#   #         "origin" => "SFO",
#   #         "destination"=> airline_code,
#   #         "date"=> "2015-03-13"
#   #       }
#   #       ],
#   #       "passengers"=> {
#   #         "adultCount"=> 1
#   #         },
#   #         "solutions"=> 5,
#   #         "refundable"=> false
#   #       }
#   # }.to_json

#     # response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=",
#     #   body: request,
#     #   headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

#     p '=' * 1000

#     responses_counter = 0
#     5.times do

#       # if response['trips']['data']['airport'] == nil
#       #   @error = 'No flight found with this search'
#       # elsif response['trips']['tripOption'][responses_counter] == nil
#       #   @error
#       # # else
#       #   sale_total = response['trips']['tripOption'][responses_counter]['saleTotal'].reverse.chomp('DSU').reverse.to_f

#       #   # carrier = response['trips']['data']['carrier'][responses_counter]['name']

#       #   carrier_code = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['flight']['carrier']

#       #   flight_number = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['flight']['number']

#       #   departure_time = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg'][0]['departureTime']

#       #   arrival_time = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg'][-1]['arrivalTime']

#       #   # CALCULATING TOTAL DURATION OF FLIGHT
#       #   total_duration = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg']
#       #   all_leg_durations = []
#         # total_duration.each do |leg|
#         #   all_leg_durations << leg['duration']
#         # end
#         # total_travel_time = all_leg_durations.reduce(:+)

#         # CALCULATING TOTAL MILEAGE TRAVELED
#         total_mileage = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg']
#         all_leg_mileages = []
#         total_mileage.each do |leg|
#           all_leg_mileages << leg['mileage']
#         end
#         total_distance_traveled = all_leg_mileages.reduce(:+)


#         origin = response['trips']['data']['city'][-1]['name']

#         destination = response['trips']['data']['city'][0]['name']

#         def convert_date_to_time(date_time)
#           date = Date.parse(date_time)
#           date = date.to_s
#           time = date_time[11..15]
#           date + " at " + time
#         end

#         Trip.create(sale_total: sale_total, carrier_code: carrier_code, flight_number: flight_number, depart_time: convert_date_to_time(departure_time), arrival_time: convert_date_to_time(arrival_time), duration: total_travel_time, mileage: total_distance_traveled, origin: origin, destination: destination)

#         # responses_counter += 1
#       end
#   # end
# end
