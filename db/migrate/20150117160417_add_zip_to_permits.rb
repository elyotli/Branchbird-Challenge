class AddZipToPermits < ActiveRecord::Migration
  def change
    add_column :permits, :zip, :string
  end
end
