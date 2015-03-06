# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'httparty'


airline_codes =
["ATL","PEK","LHR","ORD","HND","LAX","CDG","DFW","FRA","HKG","DEN","DXB","CGK","AMS","MAD","BKK","JFK","SIN","CAN","LAS","PVG","SFO","PHX","IAH","CLT","MIA","MUC","KUL","FCO","IST","SYD","MCO","ICN","DEL","BCN","LGW","EWR","YYZ","SHA","MSP","SEA","DTW","PHL","BOM","GRU","MNL","CTU","BOS","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","LGA","FLL","IAD","PMI","CPH","SVO","BWI","KMG","VIE","OSL","JED","BNE","SLC","DUS","BOG","MXP","JNB","ARN","MAN","MDW","DCA","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","SAN","TPA","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL"]

airline_codes.each do |airline_code|

request = {
  "request" => {
    "slice"=> [
      {
        "origin" => "SFO",
        "destination"=> airline_code,
        "date"=> "2015-03-13"
      }
    ],
    "passengers"=> {
      "adultCount"=> 1
    },
    "solutions"=> 1,
    "refundable"=> false
  }
}.to_json

response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyB9sDMOUjCNYYrn4K0A_CxPmEF7v2k741g",
body: request,
headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

sale_total = response['trips']['tripOption'][0]['saleTotal'].reverse.chomp('DSU').reverse.to_f

carrier = response['trips']['data']['carrier'][0]['name']

carrier_code = response['trips']['tripOption'][0]['slice'][0]['segment'][0]['flight']['carrier']

flight_number = response['trips']['tripOption'][0]['slice'][0]['segment'][0]['flight']['number']

departure_time = response['trips']['tripOption'][0]['slice'][0]['segment'][0]['leg'][0]['departureTime']

arrival_time = response['trips']['tripOption'][0]['slice'][0]['segment'][0]['leg'][0]['arrivalTime']

duration = response['trips']['tripOption'][0]['slice'][0]['segment'][0]['leg'][0]['duration']

mileage = response['trips']['tripOption'][0]['slice'][0]['segment'][0]['leg'][0]['mileage']

origin = response['trips']['data']['city'][1]['name']

destination = response['trips']['data']['city'][0]['name']

Trip.create(sale_total: sale_total, carrier: carrier, carrier_code: carrier_code, flight_number: flight_number, depart_time: departure_time, arrival_time: arrival_time, duration: duration, mileage: mileage)

end
