class Plan < ApplicationRecord
    validates :name, presence: true

    def formatted_name
        if self.number_to_currency.present?
            "#{self.name} (#{number_to_currency(self.price_in_cents)})"
        else 
            "#{self.name} (#{number_to_currency(0)})"
        end
    end

end
