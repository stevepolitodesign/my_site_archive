class User < ApplicationRecord
  include Pay::Billable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :websites, dependent: :destroy


  validates :accepted_terms, inclusion: { in: [true] }
  validates :accepted_terms, exclusion: { in: [nil,false] }

  scope :with_active_subscriptions, -> { joins(:subscriptions).where({ pay_subscriptions: { status: "active" } }).distinct }
  scope :with_websites, -> { joins(:websites).distinct }

  def card_on_file
    if has_card?
      "#{card_type} #{card_last4} expiring on #{card_exp_month}/#{card_exp_year}"
    end
  end
  
  def current_plan
    Plan.find_by(processor_id: self.subscription.processor_plan) unless self.subscription.nil?
  end
  
  def current_plan_job_schedule_frequency
    return if current_plan.nil?
    self.current_plan.job_schedule_frequency
  end

  def destroy
    self.subscription.cancel_now! if self.subscribed?
    rescue Pay::Error
    super
  end

  def has_card?
    card_type.present? && card_last4.present? && card_exp_month.present? && card_exp_year.present?
  end

end
