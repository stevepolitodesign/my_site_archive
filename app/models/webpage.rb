require 'uri'

class Webpage < ApplicationRecord
	belongs_to :website
  	has_many :screenshots, dependent: :destroy
	has_one :latest_screenshot, -> { order(created_at: :desc) }, class_name: "Screenshot"

  	validates :title, :url, presence: true
  	validates :url, url: true
	validate :url_should_match_website_url
	validate :user_webpage_limit, on: :create

	scope :with_active_subscribers, -> {
		joins(website: [:user, user: [:subscriptions]])
		.where({ pay_subscriptions: { status: "active" } }).distinct
    }

	def capture_new_screenshot
		CreateScreenshotJob.perform_later(self.id)
	end
	
	def should_capture_new_screenshot?
        return true if self.latest_screenshot.nil?
        if duration.present?
            case duration
            when "week"
                return difference_between_screenshot_dates > 7
            end
        else
            return false
		end
    end	

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
				errors.add(:base, "You have reached your webpage limit.") if self.website.webpages.count >= self.website.user.current_plan.webpage_limit
			end
		end

		def duration
            self.website.user.current_plan_job_schedule_frequency
		end

		def difference_between_screenshot_dates
            (1.send(duration).from_now.to_date - self.latest_screenshot.created_at.to_date).to_i
		end
end
