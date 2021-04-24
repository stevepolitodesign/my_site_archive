require 'uri'

module Domainable
	extend ActiveSupport::Concern

	def remove_path_from_url
		self.url = URI.join(self.url, "/").to_s
	end

end