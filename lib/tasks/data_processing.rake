namespace :data do
  desc ""
  task :search_crimes => :environment do
  	ap get_crime_type_distribution
  	# (2006..2014).each do |year|
  	# 	puts "in year #{year}:"
  	# 	total_chicago = get_crimes_by_year(year).count
  	# 	puts total_chicago
  	# 	puts west_area = get_crimes_by_year_by_district(year, [12, 13, 14]).count
  	# 	puts uptown = get_crimes_by_year_by_district(year, [3]).count
  	# 	puts (west_area+uptown)*1.0/total_chicago
  	# 	# west_area_crimes = get_crimes_by_year_by_district(year, [12, 13, 14])
  	# 	# ap pie_graph_prep(num_to_percent(get_crime_type_distribution(west_area_crimes)))
  	# end
  end

  task :search_permits => :environment do
  	(2006..2014).each do |year|
  		puts "in year #{year}:"
  		total_chicago = get_permits_by_year(year).count
  		puts total_chicago
  		puts "in high growth areas:"
  		high_count =  get_permits_by_year_by_zip(year, ['60647', '60622', '60606', '60607']).count
  		puts high_count
  		puts high_count*1.0/total_chicago
  	end
  	# ap get_permit_zip_distribution
  end

end


#basic queries___________________________

def get_crimes_by_year(year)
	Crime.where('(extract(year from date)) = ?', year)
end

def get_crimes_by_year_by_district(year, district)
	#west-loop, wicker park, logan square districts are 12-14, uptown is 3
	# source: https://arrestjustice.files.wordpress.com/2011/06/chicago-police-district-map-community-areas.jpg
	Crime.where('(extract(year from date)) = ? AND district in (?)', year, district)
end

def get_crimes_by_year_by_district_by_type(year, district, type)
	Crime.where('(extract(year from date)) = ? AND district in (?) AND primary_type = ?', year, district, type)
end

def get_crime_type_distribution(data = Crime.all)
	data.group(:district).distinct.count(:id)
end

def get_permit_zip_distribution(data = Permit.all)
	data.group(:zip).distinct.count(:id)
end

def get_permits_by_year(year)
	Permit.where('(extract(year from date)) = ?', year)
end

def get_permits_by_year_by_zip(year, zip)
	# only new construction permits
	# logan square, west-loop, wicker park zip codes are 60647, 60622, 60606, 60607
	# uptown is 60640
	# source: http://www.chicagorealestatelocal.com/images/chicago-zip-code-map.GIF
	Permit.where('(extract(year from date)) = ? AND zip in (?)', year, zip)
end

def num_to_percent(input_hash)
	sum = input_hash.values.inject(:+)
	puts "total number is #{sum}"
	percent_hash = input_hash.each { |k, v| input_hash[k]=(v*1.0/sum) }
end

def pie_graph_prep(input_hash)
	other_filter = 0.03
	output = Hash[input_hash.sort_by {|_key, value| value}.reverse]
	output = output.select{|k, v| v>other_filter}
	output["OTHER"] = 1 - output.values.inject(:+)
	return output
end
