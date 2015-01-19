# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# if i'm buying a home, is it safe to buy into "up and coming"?

# hypothesis: up-and-coming neighborhoods will have a general decrease in crime rate and also a decrease in severity of crimes

require 'csv'

def import_crimes
	#total lines in crimes file: 4589119
	missed_data = 0
	CSV.foreach(File.dirname(__FILE__)+'/Crimes_-_2001_to_present.csv', :headers => true) do |row|
		index = $.
		puts 'reading ' + index.to_s + " out of 4589119 lines"
		begin
			crime_date = Date.strptime(row['Date'], "%m/%d/%Y")
			abort("Imported all data prior to 2005, ending program") if crime_date.year == 2005 #our permits data starts from 2006
			insert_command = "INSERT INTO Crimes (crime_id, date, primary_type, arrest, domestic, district, ward, latitude, longitude)" + 
				" VALUES (#{row['ID']}, \'#{crime_date}\', \'#{row['Primary Type']}\', #{row['Arrest']}, #{row['Domestic']}, #{row['District']}, #{row['Ward']}, #{row['Latitude']}, #{row['Longitude']});"
			ActiveRecord::Base.connection.execute(insert_command)
		rescue
			puts "could not add #{row} due to nil data"
			missed_data += 1
			puts missed_data.to_s + " records were not imported"
		end
	end
	puts missed_data.to_s + " records were not imported"
end

def import_permits
	#total lines in crimes file: 375370
	missed_data = 0
	CSV.foreach(File.dirname(__FILE__)+'/Building_Permits.csv', :headers => true) do |row|
		index = $.
		puts 'reading ' + index.to_s + " out of 375370 lines"
		begin
			unless row['         ISSUE_DATE'].nil? # to deal with those blank rows
				permit_date = Date.strptime(row['         ISSUE_DATE'], "%m/%d/%Y") 
				insert_command = "INSERT INTO Permits (permit_id, date, permit_type, latitude, longitude)" + 
					" VALUES (#{row['ID']}, \'#{permit_date}\', \'#{row['  PERMIT_TYPE']}\', #{row['LATITUDE']}, #{row['LONGITUDE']});"
				ActiveRecord::Base.connection.execute(insert_command)
			end
		rescue
			puts "could not add #{row} due to nil data"
			missed_data += 1
			puts missed_data.to_s + " records were not imported"
		end
	end
	puts missed_data.to_s + " records were not imported"
end

def import_zip_coordinates
	#source: http://www.boutell.com/zipcodes/
	CSV.foreach(File.dirname(__FILE__)+'/zipcode.csv', :headers => true) do |row|
		index = $.
		puts "reading line #{index}"
		if row['state'] == "IL" && row['city'] == "Chicago" && row['latitude'].nil? == false
			insert_command = "INSERT INTO zip_coordinates (zip, latitude, longitude)" + 
				" VALUES (\'#{row['zip']}\', #{row['latitude']}, #{row['longitude']});"
			ActiveRecord::Base.connection.execute(insert_command)
		end
	end
end

def populate_permit_zip
	counter = 0
	Permit.all.each do |p|
		if p.permit_type == "PERMIT - NEW CONSTRUCTION"
			#13421 new construction permits total
			p.populate_zip
			counter +=1
			puts counter
		end
	end
end

# import_crimes
# import_permits
# import_zip_coordinates
# populate_permit_zip