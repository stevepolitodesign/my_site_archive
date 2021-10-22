class RedemptionCode < ApplicationRecord
  belongs_to :plan
  has_one :redemption, dependent: :restrict_with_error
  has_one :redeemed_code, through: :redemption

  validates :value, presence: true
  validates :value, uniqueness: true  
end