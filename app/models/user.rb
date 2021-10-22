class User < ApplicationRecord
  include Chargable
  include Pay::Billable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :archives, dependent: :destroy
  has_many :websites, dependent: :destroy
  has_one :redemption, dependent: :destroy
  has_one :redeemed_code, through: :redemption, source: :redemption_code

  validates :accepted_terms, inclusion: { in: [true] }
  validates :accepted_terms, exclusion: { in: [nil,false] }
  
  scope :confirmed, -> { where.not(confirmed_at: nil) }
  scope :guest, -> { where(guest: true) }
  scope :not_confirmed, -> { where(confirmed_at: nil) }
  scope :with_active_subscriptions, -> { joins(:subscriptions).where({ pay_subscriptions: { status: "active" } }).distinct }
  scope :with_free_trial_ending_on, -> (date) { where(trial_ends_at: date) }
  scope :with_websites, -> { joins(:websites).distinct }
  
  def current_plan
    Plan.find_by(processor_id: self.subscription.processor_plan) unless self.subscription.nil?
  end
  
  def current_plan_job_schedule_frequency
    return if current_plan.nil?
    self.current_plan.job_schedule_frequency
  end

  def destroy
    self.subscription.cancel_now! if self.subscribed?
    super
    rescue Pay::Error
    super
  end

end
