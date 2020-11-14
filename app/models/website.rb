require 'uri'

class Website < ApplicationRecord
    belongs_to :user
    has_many :webpages, dependent: :destroy
    has_many :zone_files, dependent: :destroy
    has_one :latest_zone_file, -> { order('created_at') }, class_name: "ZoneFile"

    validates :title, :url, presence: true
    validates :url, url: true
    validate :associated_user_should_have_an_active_subscription

    before_save :remove_path_from_url

    private

        def remove_path_from_url
            self.url = URI.join(self.url, "/").to_s
        end

        def associated_user_should_have_an_active_subscription
            errors.add(:base, "You need an active subscription to perform this action.") unless self.user.subscribed?
        end
end
