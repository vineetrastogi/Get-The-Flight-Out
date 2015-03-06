# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
require 'httparty'

request = {
  "request" => {
    "slice"=> [
      {
        "origin" => "SFO",
        "destination"=> "SEA",
        "date"=> "2015-04-29"
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

p response
