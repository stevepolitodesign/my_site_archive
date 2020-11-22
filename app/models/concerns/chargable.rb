module Chargable
    extend ActiveSupport::Concern

    included do
        :card_on_file
        :has_card?
    end

    def card_on_file
        if has_card?
          "#{card_type.capitalize} #{card_last4} expiring on #{card_exp_month}/#{card_exp_year}"
        end
    end

    def has_card?
        card_type.present? && card_last4.present? && card_exp_month.present? && card_exp_year.present?
    end

end