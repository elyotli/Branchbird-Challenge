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

def check_data_nil(data)
	data['ID'].nil? | data['Date'].nil? | data['Primary Type'].nil? | data['Arrest'].nil? | data['Domestic'].nil? | data['District'].nil?| data['Ward'].nil?| data['Latitude'].nil?| data['Longitude'].nil?
end

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

# import_crimes
# import_permits

#what the fuck do i do next

# filter down those fucking records
	# - permits: only take new construction and renovation
		# hook up to google maps to get zips
	# - 


#crimes, filter down only on a specific ward?
# get types of crimes
	# make buckets?
# get total number of crimes by year
# get total number of 


# make front-end

#