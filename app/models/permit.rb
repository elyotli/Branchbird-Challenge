class Permit < ActiveRecord::Base
	def populate_zip
		distance = {}
		ZipCoordinate.all.each do |z|
			distance[z.zip] = ((z.latitude - self.latitude) ** 2 + (z.latitude - self.latitude) ** 2) ** 0.5
		end
		self.zip = distance.sort_by {|_key, value| value}[0][0]
		self.save
	end

	def self.get_chicago_permits
		{2006=>45278, 2007=>45483, 2008=>40711, 2009=>39888, 2010=>38855, 2011=>35486, 2012=>34601, 2013=>34861, 2014=>37325}
	end

	def self.get_westloop_permits
		{2006=>77, 2007=>70, 2008=>42, 2009=>47, 2010=>44, 2011=>18, 2012=>28, 2013=>30, 2014=>32}
	end

	def self.get_uptown_permits
		{2006=>26, 2007=>13, 2008=>5, 2009=>3, 2010=>1, 2011=>1, 2012=>4, 2013=>4, 2014=>6}
	end
end
