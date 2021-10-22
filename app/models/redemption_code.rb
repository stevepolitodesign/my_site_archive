class RedemptionCode < ApplicationRecord
  belongs_to :plan
  has_one :redemption, dependent: :restrict_with_error
  has_one :user, through: :redemption, source: :user

  validates :value, presence: true
  validates :value, uniqueness: true  

  def ends_at
    case self.plan.interval
    when "monthly"
        1.month.from_now
    when "yearly"
        1.year.from_now
    end
  end  
end