class CreateZipCoordinates < ActiveRecord::Migration
  def change
    create_table :zip_coordinates do |t|
    	t.string :zip
    	t.float :latitude
    	t.float :longitude
    end
  end
end
