class Archive < ApplicationRecord
  include Domainable

  GUEST_USER_LIMIT = 2.freeze

  before_create :set_uuid

  belongs_to :user, counter_cache: true
  has_one :website, dependent: :destroy

  validates :user, :url, presence: true
  validates :url, url: true
  validates :uuid, uniqueness: true
  validate :limit_guest_user_archives, on: :create 

  scope :from_guest_account, -> { joins(:user).where( { user: User.guest.not_confirmed } ) }

  def generate_report(website, original_url)
    ArchiveJob.perform_later(website, original_url)
  end

  def create_website_for_report
    ActiveRecord::Base.transaction do
      domain        = remove_path_from_url
      website       = self.build_website(url: domain, title: domain, user_id: user_id)
      website.save!(validate: false)
      website
    end
  end

  private

    def limit_guest_user_archives
      errors.add(:base, "You've reached your daily limit. Want unlimited access? Sign up today for a 14 day free trial today!") if self.user.present? && self.user.archives_count >= GUEST_USER_LIMIT
    end

    def set_uuid
      self.uuid = SecureRandom.uuid
    end
end
