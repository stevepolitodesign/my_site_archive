class Redemption < ApplicationRecord
  belongs_to :redemption_code
  belongs_to :user

  validates :user, uniqueness: { scope: :redemption_code }
end
