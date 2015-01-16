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

#total lines in crimes file: 4589119
missed_data = 0

CSV.foreach(File.dirname(__FILE__)+'/Crimes_-_2001_to_present.csv', :headers => true) do |row|
	index = $.
	puts 'reading ' + index.to_s + " out of 4589119 lines"
	unless check_data_nil(row)
		#begin
			crime_date = Date.strptime(row['Date'], "%m/%d/%y")
			insert_command = "INSERT INTO Crimes (crime_id, date, primary_type, arrest, domestic, district, ward, latitude, longitude)
				VALUES (#{row['ID']}, #{crime_date}, #{row['Primary Type']}, #{row['Arrest']}, #{row['Domestic']}, #{row['District']}, #{row['Ward']}, #{row['Latitude']}, #{row['Longitude']})"
			ActiveRecord::Base.connection.execute(insert_command)

				# Crime.create(:crime_id => row['ID'],
				# :date => Date.strptime(row['Date'], "%m/%d/%y"),
			 #   	:primary_type => row['Primary Type'],
			 #   	:arrest => row['Arrest'],
			 #   	:domestic => row['Domestic'],
			 #   	:district => row['District'],
			 #   	:ward => row['Ward'],
			 #   	:latitude => row['Latitude'],
			 #   	:longitude => row['Longitude'])
		# rescue
		# 	puts "could not add #{row} due to unknown reasons"
		# 	missed_data += 1
		# 	puts missed_data.to_s + " records were not imported"
		# end
	else
		missed_data += 1
		puts missed_data.to_s + " records were not imported"
		puts row
	end
end

puts missed_data.to_s + " records were not imported"