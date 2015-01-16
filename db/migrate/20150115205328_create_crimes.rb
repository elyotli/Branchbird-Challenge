class CreateCrimes < ActiveRecord::Migration
  def change
    create_table :crimes do |t|
    	t.integer :crime_id
    	t.date :date
    	t.string :primary_type
    	t.boolean :arrest
    	t.boolean :domestic
    	t.integer :district
    	t.integer :ward
    	t.float :latitude
    	t.float :longitude

      	t.timestamps
    end
  end
end
