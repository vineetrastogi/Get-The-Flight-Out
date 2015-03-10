module DataParserHelper

  def find_city(departing_airport_code, final_response)
    hash_containing_city_code = final_response['trips']['data']['city'].select { |hash| hash.has_value?(find_city_code(departing_airport_code, final_response)) }
    return hash_containing_city_code[0]['name']
  end

  def find_city_code(departing_airport_code, final_response)
    final_response['trips']['data']['airport'].select { |hash| hash.has_value?(departing_airport_code) }[0]['city']
  end

  def convert_date_to_time(date_time)
    date = Date.parse(date_time)
    date = date.to_s
    time = date_time[11..15]
    date + " at " + time
  end

end
