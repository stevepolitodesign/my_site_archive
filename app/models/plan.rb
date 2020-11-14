require 'securerandom'

class Plan < ApplicationRecord
    include ActionView::Helpers::NumberHelper

    enum interval: [:monthly, :yearly]
    enum job_schedule_frequency: [:month]

    validates :name, presence: true

    before_create :set_uuid

    scope :available, -> { where(public: true) }

    def formatted_name
        if self.price_in_cents.present?
            "#{self.name} (#{number_to_currency(self.price_in_cents / 100)})"
        else 
            "#{self.name} (#{number_to_currency(0)})"
        end
    end

    private

        def set_uuid
            self.uuid = SecureRandom.uuid
        end

end
