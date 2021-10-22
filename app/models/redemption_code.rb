class RedemptionCode < ApplicationRecord
  belongs_to :plan
  has_one :redemption, dependent: :restrict_with_error
  has_one :user, through: :redemption, source: :user

  validates :value, presence: true
  validates :value, uniqueness: true  
end