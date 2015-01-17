class CreatePermits < ActiveRecord::Migration
  def change
    create_table :permits do |t|
    	t.integer :permit_id
    	t.string :permit_type
    	t.date :date
    	t.float :latitude
    	t.float :longitude
      	t.timestamps
    end
  end
end
