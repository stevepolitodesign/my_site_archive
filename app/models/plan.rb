class Plan < ApplicationRecord
    include ActionView::Helpers::NumberHelper

    validates :name, presence: true

    def formatted_name
        if self.price_in_cents.present?
            "#{self.name} (#{number_to_currency(self.price_in_cents / 100)})"
        else 
            "#{self.name} (#{number_to_currency(0)})"
        end
    end

end
