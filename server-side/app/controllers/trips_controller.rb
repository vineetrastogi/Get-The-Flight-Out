class TripsController < ApplicationController

  def index
    @complete_results = []
    # @all_trips = Trip.where("sale_total < ?", params[:sale_total]).order(:sale_total).sample(10)
    airport_codes =
    ["PEK","LHR","HND","CDG","FRA","HKG","DXB","CGK","AMS","MAD","BKK","SIN","CAN","PVG","MUC","KUL","FCO","IST","SYD","ICN","DEL","BCN","LGW","YYZ","SHA","BOM","GRU","MNL","CTU","SZX","MEL","NRT","ORY","MEX","DME","AYT","TPE","ZRH","PMI","CPH","SVO","KMG","VIE","OSL","JED","BNE","DUS","BOG","MXP","JNB","ARN","MAN","BRU","DUB","GMP","DOH","STN","HGH","CJU","YVR","TXL","CGH","BSB","CTS","XMN","RUH","FUK","GIG","HEL","LIS","ATH","AKL"]

    airport_codes.each do |airport|
      p params
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
              "solutions" => 5,
              "refundable" => false
        }
      }.to_json

          @response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyB9sDMOUjCNYYrn4K0A_CxPmEF7v2k741g",
            body: request,
            headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

          @complete_results << @response
      end
      render json: @complete_results
  end
end



