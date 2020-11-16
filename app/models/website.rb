require 'uri'

class Website < ApplicationRecord
    belongs_to :user
    has_many :webpages, dependent: :destroy
    has_many :zone_files, dependent: :destroy
    has_one :latest_zone_file, -> { order('created_at') }, class_name: "ZoneFile"

    validates :title, :url, presence: true
    validates :url, url: true
    validate :associated_user_should_have_an_active_subscription
    validate :user_website_limit
    
    scope :with_active_subscribers, -> {
        joins(user: :subscriptions).where({ pay_subscriptions: { status: "active" } }).distinct
    }

    before_save :remove_path_from_url

    def capture_new_html_documents(duration)
        self.webpages.each do |webpage|
            webpage.capture_new_html_document(duration)
        end
    end

    def capture_new_zone_file
        CreateZoneFileJob.perform_later(self.id)
    end

    def should_capture_new_zone_file?
        byebug
        return true if self.latest_zone_file.nil?
        if duration.present?
            difference = 1.send(duration).from_now.to_date - self.latest_zone_file.created_at.to_date
            return self.latest_zone_file.created_at <= 1.send(duration).from_now
        else
            return false
        end
    end

    private

        def remove_path_from_url
            self.url = URI.join(self.url, "/").to_s
        end

        def associated_user_should_have_an_active_subscription
            errors.add(:base, "You need an active subscription to perform this action.") unless self.user.subscribed?
        end

        def user_website_limit
            if self.user.current_plan.present? && self.user.current_plan.website_limit.present?
                errors.add(:base, "You have reached your website limit.") if self.user.websites.count >= self.user.current_plan.website_limit
            end
        end

        def duration
            self.user.current_plan_job_schedule_frequency
        end

        def difference_beween_dates
            1.send(duration).from_now.to_date - self.latest_zone_file.created_at.to_date
        end
end
