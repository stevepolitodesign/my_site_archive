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

    before_save :remove_path_from_url

    def capture_new_html_documents(duration)
        self.webpages.each do |webpage|
            webpage.capture_new_html_document(duration)
        end
    end

    def capture_new_zone_file(duration)
        @zone_file = self.latest_zone_file
        if @zone_file.nil? || @zone_file.created_at >= 1.send(duration).from_now
          CreateZoneFileJob.perform_later(self.id)
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
end
