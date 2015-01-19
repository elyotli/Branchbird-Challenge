class Permit < ActiveRecord::Base
	def populate_zip
		distance = {}
		ZipCoordinate.all.each do |z|
			distance[z.zip] = ((z.latitude - self.latitude) ** 2 + (z.latitude - self.latitude) ** 2) ** 0.5
		end
		self.zip = distance.sort_by {|_key, value| value}[0][0]
		self.save
	end
end
