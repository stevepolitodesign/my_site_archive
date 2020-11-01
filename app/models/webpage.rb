require 'uri'

class Webpage < ApplicationRecord
	belongs_to :website
	has_many :html_documents, dependent: :destroy
  	has_many :screenshots, dependent: :destroy
  	has_one :latest_html_document, -> { order('created_at') }, class_name: "HtmlDocument"

  	validates :title, :url, presence: true
  	validates :url, url: true
	validate :url_should_match_website_url

  private

	def url_should_match_website_url
		begin
			errors.add(:url, "The URL should start with #{self.website.url}.") if URI.join(self.url, "/").to_s != self.website.url
		rescue URI::InvalidURIError => exception
			errors.add(:url, "URL is not valid")
		end
    end
end
