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
    scope :with_on_going_free_trials, -> {
        joins(website: :user).where("users.trial_ends_at >= ?", Time.zone.now)
	}

	def capture_new_screenshot
		CreateScreenshotJob.perform_later(self.id)
	end

	# OPTIMIZE: Consider saving this value in a seperate database column.
	def next_scheduled_screenshot_capture
		return Time.zone.now if self.latest_screenshot.nil?
		if duration.present?
			case duration
			when "week"
				self.latest_screenshot.created_at + 7.days
			else
				Time.zone.now
			end
		else
			self.latest_screenshot.created_at + 7.days
		end
	end
	
	def should_capture_new_screenshot?
        return true if self.latest_screenshot.nil?
		next_scheduled_screenshot_capture <= Time.zone.now
	end
	

	  private

		def duration
			self.website.user.current_plan_job_schedule_frequency
		end

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
			elsif self.website.user.on_generic_trial?
				errors.add(:base, "You have reached your webpage limit.") if self.website.webpages.count >= 10
			end
		end

end
