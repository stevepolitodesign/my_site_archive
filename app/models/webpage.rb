require 'uri'

class Webpage < ApplicationRecord
	belongs_to :website
	has_many :html_documents, dependent: :destroy
  	has_many :screenshots, dependent: :destroy
	has_one :latest_html_document, -> { order('created_at') }, class_name: "HtmlDocument"
	has_one :latest_screenshot, -> { order('created_at') }, class_name: "Screenshot"

  	validates :title, :url, presence: true
  	validates :url, url: true
	validate :url_should_match_website_url
	validate :user_webpage_limit

  private

	def url_should_match_website_url
		begin
			errors.add(:url, "should start with #{self.website.url}.") if URI.join(self.url, "/").to_s != self.website.url
		rescue URI::InvalidURIError => exception
			errors.add(:url, "not valid")
		end
	end
	
	def user_webpage_limit
		if self.website.user.current_plan.present? && self.website.user.current_plan.webpage_limit.present?
			errors.add(:base, "You have reached your website limit.") if self.website.webpages.count >= self.website.user.current_plan.webpage_limit
		end
	end
end
