class User < ApplicationRecord
  include Pay::Billable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable

  has_many :websites, dependent: :destroy

  scope :with_active_subscriptions, -> { joins(:subscriptions).where({ pay_subscriptions: { status: "active" } }).distinct }
  scope :with_websites, -> { joins(:websites).distinct }

  def destroy
    self.subscription.cancel_now! if self.subscribed?
    rescue Pay::Error
    super
  end

  def current_plan
    Plan.find_by(processor_id: self.subscription.processor_plan) unless self.subscription.nil?
  end

  def current_plan_job_schedule_frequency
    return if current_plan.nil?
    self.current_plan.job_schedule_frequency
  end

  def capture_new_html_documents
    return if self.current_plan_job_schedule_frequency.nil?
    self.websites.each do |website|
      website.capture_new_html_documents(current_plan_job_schedule_frequency)
    end
  end

  def capture_new_zone_files
    return if self.current_plan_job_schedule_frequency.nil?
    self.websites.each do |website|
      website.capture_new_zone_file(current_plan_job_schedule_frequency)
    end
  end
end
