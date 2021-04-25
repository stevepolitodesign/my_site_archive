class Archive < ApplicationRecord
  include Domainable

  belongs_to :user
  has_one :website, dependent: :destroy

  # TODO: Consider adding a validation to prevent anonymous users from running too many reports
  validates :user, :url, presence: true
  validates :url, url: true

  def generate_report
    # TODO: Extract this into a Job. The job should have a low prioritiy.
    ActiveRecord::Base.transaction do
      original_url  = url
      domain        = remove_path_from_url      
      @website      = self.build_website(url: domain, title: domain, user_id: user_id)
      @website.save!(validate: false)
      @website.capture_new_zone_file
      @webpage      = @website.webpages.create(url: original_url, title: original_url)
      @webpage.capture_new_screenshot
      @website
    end
  end
end
