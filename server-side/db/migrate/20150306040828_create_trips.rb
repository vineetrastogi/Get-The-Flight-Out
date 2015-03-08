class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.float :sale_total
      t.string :carrier
      t.string :carrier_code
      t.string :flight_number
      t.string :depart_time
      t.string :arrival_time
      t.integer :duration
      t.integer :mileage
      t.string :origin
      t.string :destination
      t.string :destination_code
      t.string :airport_code

      t.timestamps null: false
    end
  end
end
