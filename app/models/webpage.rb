require 'uri'

class Webpage < ApplicationRecord
	belongs_to :website
	has_many :html_documents, dependent: :destroy
  	has_many :screenshots, dependent: :destroy
  	has_one :latest_html_document, -> { order('created_at') }, class_name: "HtmlDocument"

  	validates :title, :url, presence: true
  	validates :url, url: true

  	before_validation :set_url

  private

	# TODO: Refactor, or consider setting the  self.website.url in the form.
	def set_url
		if self.url.present?
			begin
				uri = URI::parse(self.url)
				self.url = self.website.url + uri.path
			rescue URI::InvalidURIError => exception
				self.url = self.website.url + self.url
			end
      	else
        	self.url = self.website.url
      	end
    end
end
