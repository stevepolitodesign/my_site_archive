class Redemption < ApplicationRecord
  belongs_to :redemption_code
  belongs_to :user

  validates :redemption_code, uniqueness: true
end
