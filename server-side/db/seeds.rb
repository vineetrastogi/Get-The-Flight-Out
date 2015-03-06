# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'httparty'
require 'awesome_print'
require 'date'


airline_codes =
["ATL","PEK","LHR","ORD","HND","LAX","CDG","DFW","FRA","HKG","DEN","DXB","CGK","AMS","MAD","BKK","JFK","SIN","CAN","LAS","PVG","PHX","IAH","CLT","MIA","MUC","KUL","FCO","IST","SYD","MCO","ICN","DEL","BCN","LGW","EWR","YYZ","SHA","MSP","SEA","DTW","PHL","BOM","GRU","MNL","CTU","BOS","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","LGA","FLL","IAD","PMI","CPH","SVO","BWI","KMG","VIE","OSL","JED","BNE","SLC","DUS","BOG","MXP","JNB","ARN","MAN","MDW","DCA","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","SAN","TPA","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL"]

# This statement is for later on, once the user types in their origin. It will take their input, and if it matches a string inside of the array, then we cut out the string in the array and continue with the API Call.

# if airline_codes.include?(response['trips']['data']['city'][-1]['name'])

# end

# airline_codes.each do |airline_code|

request = {
  "request" => {
    "maxPrice" => "USD500",
    "slice" => [
      {
        "origin" => "SFO",
        "destination"=> "ATL",
                # airline_code,
        "date"=> "2015-03-13"
      }
      ],
      "passengers"=> {
        "adultCount"=> 1
        },
        "solutions"=> 5,
        "refundable"=> false
      }
      }.to_json

      responses = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyB9sDMOUjCNYYrn4K0A_CxPmEF7v2k741g",
        body: request,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

      responses_counter = 0
      responses.each do |response|

        p sale_total = response['trips']['tripOption'][responses_counter]['saleTotal']
        # .reverse.chomp('DSU').reverse.to_f

        # carrier = response['trips']['data']['carrier'][responses_counter]['name']

        # carrier_code = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['flight']['carrier']

        # flight_number = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['flight']['number']

        # departure_time = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg'][0]['departureTime']

        # arrival_time = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg'][-1]['arrivalTime']

        # # CALCULATING TOTAL DURATION OF FLIGHT
        # total_duration = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg']
        # all_leg_durations = []
        # total_duration.each do |leg|
        #   all_leg_durations << leg['duration']
        # end
        # total_travel_time = all_leg_durations.reduce(:+)

        # # CALCULATING TOTAL MILEAGE TRAVELED
        # total_mileage = response['trips']['tripOption'][responses_counter]['slice'][0]['segment'][0]['leg']
        # all_leg_mileages = []
        # total_mileage.each do |leg|
        #   all_leg_mileages << leg['mileage']
        # end
        # total_distance_traveled = all_leg_mileages.reduce(:+)


        # origin = response['trips']['data']['city'][-1]['name']

        # destination = response['trips']['data']['city'][0]['name']

        # def convert_date_to_time(date_time)
        #   p date = Date.parse(date_time)
        #   date = date.to_s
        #   time = date_time[11..15]
        #   p date + " at " + time
        # end

        # Trip.create(sale_total: sale_total, carrier: carrier, carrier_code: carrier_code, flight_number: flight_number, depart_time: convert_date_to_time(departure_time), arrival_time: convert_date_to_time(arrival_time), duration: total_travel_time, mileage: total_distance_traveled, origin: origin, destination: destination)

        ap responses
        puts '*' * 100
        p responses
        responses_counter += 1
    end
# end

# {
#      "kind" => "qpxExpress#tripsSearch",
#     "trips" => {
#               "kind" => "qpxexpress#tripOptions",
#          "requestId" => "BuoKh3b3TbhxYwwrg0LhtH",
#               "data" => {
#                 "kind" => "qpxexpress#data",
#              "airport" => [
#                 [0] {
#                     "kind" => "qpxexpress#airportData",
#                     "code" => "ATL",
#                     "city" => "ATL",
#                     "name" => "Atlanta Hartsfield-Jackson ATL"
#                 },
#                 [1] {
#                     "kind" => "qpxexpress#airportData",
#                     "code" => "DFW",
#                     "city" => "DFW",
#                     "name" => "Dallas/Ft Worth International"
#                 },
#                 [2] {
#                     "kind" => "qpxexpress#airportData",
#                     "code" => "PHX",
#                     "city" => "PHX",
#                     "name" => "Phoenix Sky Harbor Int'l"
#                 },
#                 [3] {
#                     "kind" => "qpxexpress#airportData",
#                     "code" => "SFO",
#                     "city" => "SFO",
#                     "name" => "San Francisco International"
#                 }
#             ],
#                 "city" => [
#                 [0] {
#                     "kind" => "qpxexpress#cityData",
#                     "code" => "ATL",
#                     "name" => "Atlanta"
#                 },
#                 [1] {
#                     "kind" => "qpxexpress#cityData",
#                     "code" => "DFW",
#                     "name" => "Dallas/Fort Worth"
#                 },
#                 [2] {
#                     "kind" => "qpxexpress#cityData",
#                     "code" => "PHX",
#                     "name" => "Phoenix"
#                 },
#                 [3] {
#                     "kind" => "qpxexpress#cityData",
#                     "code" => "SFO",
#                     "name" => "San Francisco"
#                 }
#             ],
#             "aircraft" => [
#                 [0] {
#                     "kind" => "qpxexpress#aircraftData",
#                     "code" => "321",
#                     "name" => "Airbus A321"
#                 },
#                 [1] {
#                     "kind" => "qpxexpress#aircraftData",
#                     "code" => "738",
#                     "name" => "Boeing 737"
#                 },
#                 [2] {
#                     "kind" => "qpxexpress#aircraftData",
#                     "code" => "M80",
#                     "name" => "MD-80"
#                 }
#             ],
#                  "tax" => [
#                 [0] {
#                     "kind" => "qpxexpress#taxData",
#                       "id" => "ZP",
#                     "name" => "US Flight Segment Tax"
#                 },
#                 [1] {
#                     "kind" => "qpxexpress#taxData",
#                       "id" => "XF",
#                     "name" => "US Passenger Facility Charge"
#                 },
#                 [2] {
#                     "kind" => "qpxexpress#taxData",
#                       "id" => "US_001",
#                     "name" => "US Transportation Tax"
#                 },
#                 [3] {
#                     "kind" => "qpxexpress#taxData",
#                       "id" => "AY_001",
#                     "name" => "US September 11th Security Fee"
#                 }
#             ],
#              "carrier" => [
#                 [0] {
#                     "kind" => "qpxexpress#carrierData",
#                     "code" => "US",
#                     "name" => "US Airways, Inc."
#                 }
#             ]
#         },
#         "tripOption" => [
#             [0] {
#                      "kind" => "qpxexpress#tripOption",
#                 "saleTotal" => "USD335.60",
#                        "id" => "0cQhDpFHLLHRITBEBWDS74002",
#                     "slice" => [
#                     [0] {
#                             "kind" => "qpxexpress#sliceInfo",
#                         "duration" => 363,
#                          "segment" => [
#                             [0] {
#                                                "kind" => "qpxexpress#segmentInfo",
#                                            "duration" => 204,
#                                              "flight" => {
#                                     "carrier" => "US",
#                                      "number" => "1368"
#                                 },
#                                                  "id" => "G73DgiBCUfMEwY-d",
#                                               "cabin" => "COACH",
#                                         "bookingCode" => "G",
#                                    "bookingCodeCount" => 6,
#                                 "marriedSegmentGroup" => "0",
#                                                 "leg" => [
#                                     [0] {
#                                                        "kind" => "qpxexpress#legInfo",
#                                                          "id" => "Lcf-F8hxoZgULqL6",
#                                                    "aircraft" => "738",
#                                                 "arrivalTime" => "2015-03-13T13:30-05:00",
#                                               "departureTime" => "2015-03-13T08:06-07:00",
#                                                      "origin" => "SFO",
#                                                 "destination" => "DFW",
#                                              "originTerminal" => "2",
#                                         "destinationTerminal" => "0",
#                                                    "duration" => 204,
#                                         "operatingDisclosure" => "OPERATED BY AMERICAN AIRLINES INC.",
#                                           "onTimePerformance" => 87,
#                                                     "mileage" => 1461,
#                                                        "meal" => "Food for Purchase",
#                                                      "secure" => true
#                                     }
#                                 ],
#                                  "connectionDuration" => 40
#                             },
#                             [1] {
#                                                "kind" => "qpxexpress#segmentInfo",
#                                            "duration" => 119,
#                                              "flight" => {
#                                     "carrier" => "US",
#                                      "number" => "125"
#                                 },
#                                                  "id" => "GABtVKpjf8Tmww2b",
#                                               "cabin" => "COACH",
#                                         "bookingCode" => "G",
#                                    "bookingCodeCount" => 6,
#                                 "marriedSegmentGroup" => "0",
#                                                 "leg" => [
#                                     [0] {
#                                                        "kind" => "qpxexpress#legInfo",
#                                                          "id" => "L6th2y1KG9GJQ-gK",
#                                                    "aircraft" => "M80",
#                                                 "arrivalTime" => "2015-03-13T17:09-04:00",
#                                               "departureTime" => "2015-03-13T14:10-05:00",
#                                                      "origin" => "DFW",
#                                                 "destination" => "ATL",
#                                              "originTerminal" => "0",
#                                         "destinationTerminal" => "N",
#                                                    "duration" => 119,
#                                         "operatingDisclosure" => "OPERATED BY AMERICAN AIRLINES INC.",
#                                           "onTimePerformance" => 83,
#                                                     "mileage" => 729,
#                                                        "meal" => "Food for Purchase",
#                                                      "secure" => true
#                                     }
#                                 ]
#                             }
#                         ]
#                     }
#                 ],
#                   "pricing" => [
#                     [0] {
#                                        "kind" => "qpxexpress#pricingInfo",
#                                        "fare" => [
#                             [0] {
#                                        "kind" => "qpxexpress#fareInfo",
#                                          "id" => "AK5pLpJaK3qONiMzC0XpTZRiHwwjD4sowqj9Ic7H+Urs",
#                                     "carrier" => "US",
#                                      "origin" => "SFO",
#                                 "destination" => "ATL",
#                                   "basisCode" => "GA00ZNX3"
#                             }
#                         ],
#                              "segmentPricing" => [
#                             [0] {
#                                              "kind" => "qpxexpress#segmentPricing",
#                                            "fareId" => "AK5pLpJaK3qONiMzC0XpTZRiHwwjD4sowqj9Ic7H+Urs",
#                                         "segmentId" => "GABtVKpjf8Tmww2b",
#                                 "freeBaggageOption" => [
#                                     [0] {
#                                                  "kind" => "qpxexpress#freeBaggageAllowance",
#                                         "bagDescriptor" => [
#                                             [0] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "ASSISTIVE DEVICES",
#                                                          "count" => 0,
#                                                        "subcode" => "0GM"
#                                             },
#                                             [1] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "INFANT CAR SEAT",
#                                                          "count" => 0,
#                                                    "description" => [
#                                                     [0] "Infant Car Seat"
#                                                 ],
#                                                        "subcode" => "0G5"
#                                             },
#                                             [2] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "STROLLER OR PUSHCHAIR",
#                                                          "count" => 0,
#                                                    "description" => [
#                                                     [0] "Stroller/Pushchair"
#                                                 ],
#                                                        "subcode" => "0F4"
#                                             }
#                                         ],
#                                                "pieces" => 0
#                                     }
#                                 ]
#                             },
#                             [1] {
#                                              "kind" => "qpxexpress#segmentPricing",
#                                            "fareId" => "AK5pLpJaK3qONiMzC0XpTZRiHwwjD4sowqj9Ic7H+Urs",
#                                         "segmentId" => "G73DgiBCUfMEwY-d",
#                                 "freeBaggageOption" => [
#                                     [0] {
#                                                  "kind" => "qpxexpress#freeBaggageAllowance",
#                                         "bagDescriptor" => [
#                                             [0] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "ASSISTIVE DEVICES",
#                                                          "count" => 0,
#                                                        "subcode" => "0GM"
#                                             },
#                                             [1] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "INFANT CAR SEAT",
#                                                          "count" => 0,
#                                                    "description" => [
#                                                     [0] "Infant Car Seat"
#                                                 ],
#                                                        "subcode" => "0G5"
#                                             },
#                                             [2] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "STROLLER OR PUSHCHAIR",
#                                                          "count" => 0,
#                                                    "description" => [
#                                                     [0] "Stroller/Pushchair"
#                                                 ],
#                                                        "subcode" => "0F4"
#                                             }
#                                         ],
#                                                "pieces" => 0
#                                     }
#                                 ]
#                             }
#                         ],
#                               "baseFareTotal" => "USD291.16",
#                               "saleFareTotal" => "USD291.16",
#                                "saleTaxTotal" => "USD44.44",
#                                   "saleTotal" => "USD335.60",
#                                  "passengers" => {
#                                   "kind" => "qpxexpress#passengerCounts",
#                             "adultCount" => 1
#                         },
#                                         "tax" => [
#                             [0] {
#                                       "kind" => "qpxexpress#taxInfo",
#                                         "id" => "US_001",
#                                 "chargeType" => "GOVERNMENT",
#                                       "code" => "US",
#                                    "country" => "US",
#                                  "salePrice" => "USD21.84"
#                             },
#                             [1] {
#                                       "kind" => "qpxexpress#taxInfo",
#                                         "id" => "AY_001",
#                                 "chargeType" => "GOVERNMENT",
#                                       "code" => "AY",
#                                    "country" => "US",
#                                  "salePrice" => "USD5.60"
#                             },
#                             [2] {
#                                       "kind" => "qpxexpress#taxInfo",
#                                         "id" => "XF",
#                                 "chargeType" => "GOVERNMENT",
#                                       "code" => "XF",
#                                    "country" => "US",
#                                  "salePrice" => "USD9.00"
#                             },
#                             [3] {
#                                       "kind" => "qpxexpress#taxInfo",
#                                         "id" => "ZP",
#                                 "chargeType" => "GOVERNMENT",
#                                       "code" => "ZP",
#                                    "country" => "US",
#                                  "salePrice" => "USD8.00"
#                             }
#                         ],
#                             "fareCalculation" => "SFO US X/DFW US ATL Q SFOATL23.25 267.91GA00ZNX3 USD 291.16 END ZP SFO DFW XT 21.84US 8.00ZP 5.60AY 9.00XF SFO4.50 DFW4.50",
#                         "latestTicketingTime" => "2015-03-07T23:59-05:00",
#                                         "ptc" => "ADT"
#                     }
#                 ]
#             },
#             [1] {
#                      "kind" => "qpxexpress#tripOption",
#                 "saleTotal" => "USD361.10",
#                        "id" => "0cQhDpFHLLHRITBEBWDS74001",
#                     "slice" => [
#                     [0] {
#                             "kind" => "qpxexpress#sliceInfo",
#                         "duration" => 398,
#                          "segment" => [
#                             [0] {
#                                                "kind" => "qpxexpress#segmentInfo",
#                                            "duration" => 398,
#                                              "flight" => {
#                                     "carrier" => "US",
#                                      "number" => "610"
#                                 },
#                                                  "id" => "GCgQZdrZdLGQdML2",
#                                               "cabin" => "COACH",
#                                         "bookingCode" => "V",
#                                    "bookingCodeCount" => 9,
#                                 "marriedSegmentGroup" => "0",
#                                                 "leg" => [
#                                     [0] {
#                                                        "kind" => "qpxexpress#legInfo",
#                                                          "id" => "LAPMILwXUc6y4kke",
#                                                    "aircraft" => "321",
#                                                 "arrivalTime" => "2015-03-13T07:55-07:00",
#                                               "departureTime" => "2015-03-13T06:00-07:00",
#                                                      "origin" => "SFO",
#                                                 "destination" => "PHX",
#                                              "originTerminal" => "1",
#                                         "destinationTerminal" => "4",
#                                                    "duration" => 115,
#                                           "onTimePerformance" => 97,
#                                                     "mileage" => 650,
#                                                      "secure" => true,
#                                          "connectionDuration" => 64
#                                     },
#                                     [1] {
#                                                        "kind" => "qpxexpress#legInfo",
#                                                          "id" => "LvgmyCBcIRh6CIQp",
#                                                    "aircraft" => "321",
#                                                 "arrivalTime" => "2015-03-13T15:38-04:00",
#                                               "departureTime" => "2015-03-13T08:59-07:00",
#                                                      "origin" => "PHX",
#                                                 "destination" => "ATL",
#                                              "originTerminal" => "4",
#                                         "destinationTerminal" => "N",
#                                                    "duration" => 219,
#                                                     "mileage" => 1583,
#                                                        "meal" => "Food for Purchase",
#                                                      "secure" => true
#                                     }
#                                 ]
#                             }
#                         ]
#                     }
#                 ],
#                   "pricing" => [
#                     [0] {
#                                        "kind" => "qpxexpress#pricingInfo",
#                                        "fare" => [
#                             [0] {
#                                        "kind" => "qpxexpress#fareInfo",
#                                          "id" => "AEjnjhrlNM58qbwatp552hhLeSTxjWzfsvANV32Tpg7g",
#                                     "carrier" => "US",
#                                      "origin" => "SFO",
#                                 "destination" => "ATL",
#                                   "basisCode" => "VA00ZNH3"
#                             }
#                         ],
#                              "segmentPricing" => [
#                             [0] {
#                                              "kind" => "qpxexpress#segmentPricing",
#                                            "fareId" => "AEjnjhrlNM58qbwatp552hhLeSTxjWzfsvANV32Tpg7g",
#                                         "segmentId" => "GCgQZdrZdLGQdML2",
#                                 "freeBaggageOption" => [
#                                     [0] {
#                                                  "kind" => "qpxexpress#freeBaggageAllowance",
#                                         "bagDescriptor" => [
#                                             [0] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "ASSISTIVE DEVICES",
#                                                          "count" => 0,
#                                                        "subcode" => "0GM"
#                                             },
#                                             [1] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "INFANT CAR SEAT",
#                                                          "count" => 0,
#                                                    "description" => [
#                                                     [0] "Infant Car Seat"
#                                                 ],
#                                                        "subcode" => "0G5"
#                                             },
#                                             [2] {
#                                                           "kind" => "qpxexpress#bagDescriptor",
#                                                 "commercialName" => "STROLLER OR PUSHCHAIR",
#                                                          "count" => 0,
#                                                    "description" => [
#                                                     [0] "Stroller/Pushchair"
#                                                 ],
#                                                        "subcode" => "0F4"
#                                             }
#                                         ],
#                                                "pieces" => 0
#                                     }
#                                 ]
#                             }
#                         ],
#                               "baseFareTotal" => "USD319.06",
#                               "saleFareTotal" => "USD319.06",
#                                "saleTaxTotal" => "USD42.04",
#                                   "saleTotal" => "USD361.10",
#                                  "passengers" => {
#                                   "kind" => "qpxexpress#passengerCounts",
#                             "adultCount" => 1
#                         },
#                                         "tax" => [
#                             [0] {
#                                       "kind" => "qpxexpress#taxInfo",
#                                         "id" => "US_001",
#                                 "chargeType" => "GOVERNMENT",
#                                       "code" => "US",
#                                    "country" => "US",
#                                  "salePrice" => "USD23.94"
#                             },
#                             [1] {
#                                       "kind" => "qpxexpress#taxInfo",
#                                         "id" => "AY_001",
#                                 "chargeType" => "GOVERNMENT",
#                                       "code" => "AY",
#                                    "country" => "US",
#                                  "salePrice" => "USD5.60"
#                             },
#                             [2] {
#                                       "kind" => "qpxexpress#taxInfo",
#                                         "id" => "XF",
#                                 "chargeType" => "GOVERNMENT",
#                                       "code" => "XF",
#                                    "country" => "US",
#                                  "salePrice" => "USD4.50"
#                             },
#                             [3] {
#                                       "kind" => "qpxexpress#taxInfo",
#                                         "id" => "ZP",
#                                 "chargeType" => "GOVERNMENT",
#                                       "code" => "ZP",
#                                    "country" => "US",
#                                  "salePrice" => "USD8.00"
#                             }
#                         ],
#                             "fareCalculation" => "SFO US ATL Q23.25 295.81VA00ZNH3 USD 319.06 END ZP SFO PHX XT 23.94US 8.00ZP 5.60AY 4.50XF SFO4.50",
#                         "latestTicketingTime" => "2015-03-07T23:59-05:00",
#                                         "ptc" => "ADT"
#                     }
#                 ]
#             }
#         ]
#     }
# }

