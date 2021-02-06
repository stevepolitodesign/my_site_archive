class User < ApplicationRecord
  include Chargable
  include Pay::Billable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :websites, dependent: :destroy


  validates :accepted_terms, inclusion: { in: [true] }
  validates :accepted_terms, exclusion: { in: [nil,false] }

  scope :with_active_subscriptions, -> { joins(:subscriptions).where({ pay_subscriptions: { status: "active" } }).distinct }
  scope :with_expiring_free_trials_in_days, -> (number_of_days_left) { where("trial_ends_at >= :start_date AND trial_ends_at <= :end_date", start_date: Time.zone.now, end_date: number_of_days_left.days.from_now  ) }
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
